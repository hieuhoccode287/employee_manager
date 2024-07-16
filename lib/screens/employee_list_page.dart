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
      'position': 'Quản lý sản phẩm',
      'department': 'Quản lý sản phẩm',
      'email': 'jane.smith@example.com',
      'phone': '+1 (234) 567-8901',
      'address': '456 Đường Phong, Thành phố, Quốc gia'
    },
    {
      'name': 'Kana Mouth',
      'position': 'Quản lý sản phẩm',
      'department': 'Quản lý sản phẩm',
      'email': 'kana.mouth@example.com',
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
  String selectedDepartment = 'Tất cả';

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees; // Initialize filteredEmployees with all employees
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filterEmployees();
    });
  }

  void updateSelectedDepartment(String? newDepartment) {
    setState(() {
      selectedDepartment = newDepartment!;
      filterEmployees();
    });
  }

  void filterEmployees() {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final matchesSearchQuery = employee['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final matchesDepartment = selectedDepartment == 'Tất cả' ||
            employee['department'] == selectedDepartment;
        return matchesSearchQuery && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Danh sách nhân viên',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm nhân viên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) => updateSearchQuery(query),
                  ),
                ),
                SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (value) {
                    updateSelectedDepartment(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return <String>[
                      'Tất cả',
                      'Kỹ thuật',
                      'Quản lý sản phẩm',
                      'Thiết kế',
                      'Dữ liệu',
                      'Đảm bảo chất lượng'
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
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
