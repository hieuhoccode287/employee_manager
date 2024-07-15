import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class CompetencyProfileDetailPage extends StatelessWidget {
  final Map<String, String> employee;

  const CompetencyProfileDetailPage({required this.employee});

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
                        child: Text(
                          employee['name']![0],
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
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
                    SizedBox(height: 12),
                    Text(
                      'Kỹ năng:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['skills'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kinh nghiệm:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['experience'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Học vấn:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['education'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chứng chỉ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['certifications'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dự án:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['projects'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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