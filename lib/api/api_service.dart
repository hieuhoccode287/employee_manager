import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.5.205:3000';  // Use your local network IP address
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
}
