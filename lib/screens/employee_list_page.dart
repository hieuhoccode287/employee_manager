import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'employee_detail_page.dart';
import 'add_employee_page.dart';

class EmployeeListPage extends StatelessWidget {
  // Dữ liệu mẫu cho danh sách nhân viên
  final List<Map<String, String>> employees = [
    {
      'name': 'John Doe',
      'position': 'Kỹ sư phần mềm',
      'department': 'Kỹ thuật',
      'email': 'john.doe@example.com',
      'phone': '+1 (123) 456-7890',
      'address': '123 Đường Chính, Thành phố, Quốc gia'
    },
    {
      'name': 'Jane Smith',
      'position': 'Quản lý Sản phẩm',
      'department': 'Quản lý Sản phẩm',
      'email': 'jane.smith@example.com',
      'phone': '+1 (234) 567-8901',
      'address': '456 Đường Phong, Thành phố, Quốc gia'
    },
    {
      'name': 'Michael Brown',
      'position': 'Thiết kế UI/UX',
      'department': 'Thiết kế',
      'email': 'michael.brown@example.com',
      'phone': '+1 (345) 678-9012',
      'address': '789 Đường Sồi, Thành phố, Quốc gia'
    },
    {
      'name': 'Emily Davis',
      'position': 'Chuyên viên Phân tích dữ liệu',
      'department': 'Dữ liệu',
      'email': 'emily.davis@example.com',
      'phone': '+1 (456) 789-0123',
      'address': '012 Đường Thông, Thành phố, Quốc gia'
    },
    {
      'name': 'Chris Wilson',
      'position': 'Đảm bảo chất lượng',
      'department': 'Đảm bảo chất lượng',
      'email': 'chris.wilson@example.com',
      'phone': '+1 (567) 890-1234',
      'address': '345 Đường Phong, Thành phố, Quốc gia'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
            child: const Text('Danh sách nhân viên',
              style: TextStyle(
                color: Colors.white, // Màu chữ của tiêu đề
              ),
            ),
        ),
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(employees[index]['name']!),
              subtitle: Text(employees[index]['position']!),
              leading: CircleAvatar(
                child: Text(
                  employees[index]['name']![0],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue, // Thay đổi màu sắc nếu cần
              ),
              onTap: () {
                // Chuyển đến trang chi tiết nhân viên
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDetailPage(employee: employees[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển đến màn hình thêm mới nhân viên
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeePage(), // Thay thế bằng màn hình thêm mới của bạn
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
