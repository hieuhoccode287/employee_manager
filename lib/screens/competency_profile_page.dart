import 'package:employee_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class CompetencyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý hồ sơ năng lực'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Text(
          'Đây là trang Quản lý hồ sơ năng lực',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
