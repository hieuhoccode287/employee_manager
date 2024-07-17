import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Map<String, String> employee;

  const EmployeeDetailPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          employee['name'] ?? 'Chi tiết Nhân viên',
          style: TextStyle(
            color: Colors.white, // Text color of the title
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployee(context);
              } else if (value == 'delete') {
                _deleteEmployee(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Sửa'),
                ),
              ),
              const PopupMenuDivider(
                height: 1, // Chiều cao của Divider
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Xóa'),
                ),
              ),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white), // Color of the back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: _buildAvatarImage(),
                        child: _buildAvatarPlaceholder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tên:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['name'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chức vụ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['position'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Chi tiết',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildDetailItem('Phòng ban', employee['department'] ?? 'Không rõ'),
                    buildDetailItem('Email', employee['email'] ?? 'Không rõ'),
                    buildDetailItem('Điện thoại', employee['phone'] ?? 'Không rõ'),
                    buildDetailItem('Địa chỉ', employee['address'] ?? 'Không rõ'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildAvatarImage() {
    if (employee['url'] != null && employee['url']!.isNotEmpty) {
      return NetworkImage(employee['url']!);
    } else {
      return AssetImage('assets/placeholder.png'); // Placeholder image
    }
  }

  Widget _buildAvatarPlaceholder() {
    if (employee['url'] != null && employee['url']!.isNotEmpty) {
      return Container(); // Or any other valid Widget
    } else {
      return Text(
        employee['name']![0],
        style: TextStyle(color: Colors.white, fontSize: 30),
      );
    }
  }


  void _editEmployee(BuildContext context) {
    // Xử lý khi người dùng chọn Sửa
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng Sửa đang được phát triển')),
    );
  }

  void _deleteEmployee(BuildContext context) {
    // Xử lý khi người dùng chọn Xóa
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng Xóa đang được phát triển')),
    );
  }
}
