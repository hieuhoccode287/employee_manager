import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
            child: const Text('Cài đặt',
              style: TextStyle(
                color: Colors.white, // Màu chữ của tiêu đề
              ),
            )
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Thông tin cá nhân'),
            leading: Icon(Icons.person, color: Colors.blue), // Thay đổi màu của biểu tượng
            onTap: () {
              // TODO: Navigate to personal information screen
            },
          ),
          Divider(
            height: 1, // Chiều cao của Divider
          ),
          ListTile(
            title: Text('Mật khẩu & Bảo mật'),
            leading: Icon(Icons.security, color: Colors.orange), // Thay đổi màu của biểu tượng
            onTap: () {
              // TODO: Navigate to password & security screen
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text('Quy định & Chính sách'),
            leading: Icon(Icons.policy, color: Colors.green), // Thay đổi màu của biểu tượng
            onTap: () {
              // TODO: Navigate to policy screen
            },
          ),
          Divider(
            height: 1, // Chiều cao của Divider
          ),
          ListTile(
            title: Text('Đăng xuất'),
            leading: Icon(Icons.exit_to_app, color: Colors.red), // Thay đổi màu của biểu tượng
            onTap: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}
