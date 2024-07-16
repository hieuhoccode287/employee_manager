import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.5:3000'; // Use your local network IP address
  static const String _loginEndpoint = '/login';
  static const String _userInfoEndpoint = '/user_info'; // Example endpoint for fetching user info

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
          'message': 'Sai tên đăng nhập hoặc mật khẩu.'
        };
      } else {
        return {
          'success': false,
          'message': 'Có lỗi xảy ra. Vui lòng thử lại.'
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến máy chủ. Vui lòng thử lại.'
      };
    }
  }

  // Add method to fetch user info
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

}
