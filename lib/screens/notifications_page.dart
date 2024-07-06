import 'package:employee_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
              child: const Text('Thông báo',
                style: TextStyle(
                  color: Colors.white, // Màu chữ của tiêu đề
                ),
              ))
      ),
      body: const Center(
          child: Text('Thông báo')
      ),
    );
  }
}
