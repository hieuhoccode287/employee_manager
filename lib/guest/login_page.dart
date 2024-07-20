import 'package:flutter/material.dart';
import 'package:employee_manager/navigation/navigation_bar.dart';
import 'package:employee_manager/api/api_service.dart'; // Import the ApiService

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load default username and password (for demo purposes)
    _usernameController.text = 'hieu123@gmail.com';
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 100),
              SizedBox(height: 20),
              _buildInputField('Email/Username', controller: _usernameController),
              SizedBox(height: 20),
              _buildInputField('Mật khẩu', isPassword: true, controller: _passwordController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _handleLogin(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Text('Đăng nhập'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Quên mật khẩu?'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label không được để trống';
          }
          return null;
        },
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    String email = _usernameController.text.trim();
    String matkhau = _passwordController.text.trim();

    final response = await ApiService.login(email, matkhau);

    if (response['success']) {
      // Show success Snackbar with duration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1), // Set duration here
        ),
      );

      // Navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationExample(email: email), // Pass the email to NavigationExample
        ),
      );
    } else {
      // Show error dialog
      _showErrorDialog(context, 'Đăng nhập không thành công', response['message']);
    }
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
