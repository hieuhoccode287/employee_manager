import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.5:3000'; // IP address of your API server
  static const String _loginEndpoint = '/login';
  static const String _userInfoEndpoint = '/user_info';
  static const String _employeesEndpoint = '/employees'; // New endpoint to fetch employees

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

  // New method to fetch employees
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
}
