import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.56.1:3000'; // IP address of your API server

  static const String _loginEndpoint = '/login';
  static Future<Map<String, dynamic>> login(String email, String matkhau) async {
    final String url = '$_baseUrl$_loginEndpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'matkhau': matkhau}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Invalid email or password.',
        };
      } else {
        return {
          'success': false,
          'message': 'An error occurred. Please try again.',
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again.',
      };
    }
  }

  static const String _userInfoEndpoint = '/user_info';
  static Future<String> fetchUserName(String email) async {
    final String url = '$_baseUrl$_userInfoEndpoint?email=$email';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hoten'];
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user info');
    }
  }

  static const String _employeesEndpoint = '/employees'; // Endpoint to fetch employees
  static Future<List<dynamic>> fetchEmployees() async {
    final String url = '$_baseUrl$_employeesEndpoint';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as List<dynamic>;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load employees');
    }
  }

  static const String _addEmployeeEndpoint = '/employees/add'; // Endpoint to add employee
  static Future<Map<String, dynamic>> addEmployee({
    required String tennv,
    required String chucvu,
    required int mapb,
    required String email,
    int? sdt,
    String? diachi,
    String? avatarUrl,
    int? manl,
  }) async {
    final String url = '$_baseUrl$_addEmployeeEndpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tennv': tennv,
          'chucvu': chucvu,
          'mapb': mapb,
          'email': email,
          'sdt': sdt,
          'diachi': diachi,
          'avatar_url': avatarUrl,
          'manl': manl,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add employee: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add employee');
    }
  }

  static const String _employeeDetailsEndpoint = '/employees/details'; // Endpoint to fetch employee details
  static Future<Map<String, dynamic>> fetchEmployeeDetails(int employeeId) async {
    final String url = '$_baseUrl$_employeeDetailsEndpoint/$employeeId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load employee details');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load employee details');
    }
  }

  static const String _updateEmployeeEndpoint = '/employees/update'; // Endpoint to update employee
  static Future<Map<String, dynamic>> updateEmployee(Map<String, dynamic> updatedEmployee) async {
    final int employeeId = updatedEmployee['id'];
    final String url = '$_baseUrl$_updateEmployeeEndpoint/$employeeId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedEmployee),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update employee: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update employee');
    }
  }

  static const String _deleteEmployeeEndpoint = '/employees'; // Endpoint to delete employee
  static Future<Map<String, dynamic>> deleteEmployee(int employeeId) async {
    final String url = '$_baseUrl$_deleteEmployeeEndpoint/$employeeId';
    try {
      // Gửi yêu cầu HTTP DELETE tới API
      var response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Xử lý phản hồi từ API
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      print('Error deleting employee: $e');
      throw Exception('Failed to delete employee');
    }
  }

  static const String _uploadEndpoint = '/upload';
  static Future<String> uploadImage(File imageFile) async {
    try {
      final String url = '$_baseUrl$_uploadEndpoint';
      final Uri uri = Uri.parse(url);

      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path)); // Ensure 'image' is used here

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['imageUrl']; // Adjust as per your API response structure
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  static String getImageUrl(String filename) {
    return '$_baseUrl$filename';
  }

  static const String _departmentsEndpoint = '/departments'; // Endpoint to fetch departments
  static Future<List<Map<String, dynamic>>> fetchDepartments() async {
    final String url = '$_baseUrl$_departmentsEndpoint';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((dept) => {
          'mapb': dept['mapb'],
          'tenpb': dept['tenpb']
        }).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load departments');
    }
  }

  static const String _competencyEndpoint = '/competencies'; // Endpoint to fetch competency
  static Future<Map<String, dynamic>> fetchCompetencyById(int manl) async {
    final String url = '$_baseUrl$_competencyEndpoint/$manl';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Ensure you handle potential nulls in the data
        return {
          'kynang': data['kynang'] ?? '',
          'kinhnghiem': data['kinhnghiem'] ?? '',
          'hocvan': data['hocvan'] ?? '',
          'chungchi': data['chungchi'] ?? '',
          'duan': data['duan'] ?? '',
        };
      } else {
        throw Exception('Failed to load competency');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load competency');
    }
  }


  static const String _updateCompetencyEndpoint = '/competencies/update'; // Endpoint to update competency
  static Future<Map<String, dynamic>> updateCompetency(int manl, Map<String, dynamic> updatedCompetency) async {
    final String url = '$_baseUrl$_updateCompetencyEndpoint/$manl';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCompetency),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update competency: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update competency');
    }
  }

  static const String _addCompetencyEndpoint = '/competencies/add'; // Endpoint to add competency

  static Future<Map<String, dynamic>> addCompetency({
    required int manl,
    required String kynang,
    required String kinhnghiem,
    required String hocvan,
    required String chungchi,
    required String duan,
  }) async {
    final String url = '$_baseUrl$_addCompetencyEndpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'manl': manl,
          'kynang': kynang,
          'kinhnghiem': kinhnghiem,
          'hocvan': hocvan,
          'chungchi': chungchi,
          'duan': duan,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'],
            'competency': responseData['competency'],
          };
        } else {
          throw Exception(responseData['message'] ?? 'Failed to add competency');
        }
      } else {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(responseData['message'] ?? 'Failed to add competency');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add competency');
    }
  }

  static const String _deleteCompetencyEndpoint = '/competencies'; // Endpoint to delete competency
  static Future<Map<String, dynamic>> deleteCompetency(int competencyId) async {
    final String url = '$_baseUrl$_deleteCompetencyEndpoint/$competencyId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'],
            'competency': responseData['competency'],
          };
        } else {
          throw Exception(responseData['message'] ?? 'Failed to delete competency');
        }
      } else {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(responseData['message'] ?? 'Failed to delete competency');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete competency');
    }
  }

  // Add a department
  static const String _addDepartmentEndpoint = '/departments/add'; // Endpoint to add department
  static Future<Map<String, dynamic>> addDepartment(String tenpb) async {
    final String url = '$_baseUrl$_addDepartmentEndpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tenpb': tenpb}),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add department: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add department');
    }
  }

  // Edit a department
  static const String _editDepartmentEndpoint = '/departments/update'; // Endpoint to edit department
  static Future<Map<String, dynamic>> editDepartment({
    required int id,
    required String tenpb,
  }) async {
    final String url = '$_baseUrl$_editDepartmentEndpoint/$id';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tenpb': tenpb}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to edit department: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to edit department');
    }
  }

  // Delete a department
  static const String _deleteDepartmentEndpoint = '/departments'; // Endpoint to delete department
  static Future<Map<String, dynamic>> deleteDepartment(int departmentId) async {
    final String url = '$_baseUrl$_deleteDepartmentEndpoint/$departmentId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'],
          };
        } else {
          throw Exception(responseData['message'] ?? 'Failed to delete department');
        }
      } else {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(responseData['message'] ?? 'Failed to delete department');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete department');
    }
  }



}
