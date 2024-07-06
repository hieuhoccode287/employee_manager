import 'package:employee_manager/main.dart';
import 'package:employee_manager/navigation/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load default username and password (for demo purposes)
    _usernameController.text = 'user1@gmail.com';
    _passwordController.text = '123456';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                _handleLogin(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0), // Add your desired horizontal padding
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

            // SizedBox(height: 10),
            // TextButton(
            //   onPressed: () {
            //   },
            //   child: Text('Đăng ký'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Replace this with your actual authentication logic
    if (username == 'user1@gmail.com' && password == '123456') {
      // Navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationExample()),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng nhập không thành công'),
            content: Text('Sai tên đăng nhập hoặc mật khẩu.'),
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
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
