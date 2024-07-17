import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.5:3000'; // IP address of your API server
  static const String _loginEndpoint = '/login';
  static const String _userInfoEndpoint = '/user_info';
  static const String _employeesEndpoint = '/employees'; // Endpoint to fetch employees
  static const String _addEmployeeEndpoint = '/employees/add'; // Endpoint to add employee
  static const String _uploadEndpoint = '/upload';

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

  static Future<Map<String, dynamic>> addEmployee({
    required String tennv,
    required String chucvu,
    required int mapb,
    required String email,
    int? sdt,
    String? diachi,
    String? avatarUrl,
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




}
