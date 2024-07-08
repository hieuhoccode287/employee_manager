import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'employee_detail_page.dart';
import 'add_employee_page.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
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

  List<Map<String, String>> filteredEmployees = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees; // Khởi tạo biến filteredEmployees với employees
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filteredEmployees = employees.where((employee) {
        return employee['name']!
            .toLowerCase()
            .contains(newQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(
          child: Text(
            'Danh sách nhân viên',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm nhân viên',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => updateSearchQuery(query),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(filteredEmployees[index]['name']!),
                    subtitle: Text(filteredEmployees[index]['position']!),
                    leading: CircleAvatar(
                      child: Text(
                        filteredEmployees[index]['name']![0],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeDetailPage(
                              employee: filteredEmployees[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
