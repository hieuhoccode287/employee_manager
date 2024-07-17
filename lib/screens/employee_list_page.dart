import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'employee_detail_page.dart';
import 'add_employee_page.dart';
import 'package:employee_manager/api/api_service.dart'; // Import ApiService

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Map<String, String>> filteredEmployees = [];
  String searchQuery = '';
  int? selectedDepartmentMapb; // Updated to int type for department ID filtering

  @override
  void initState() {
    super.initState();
    fetchEmployeesFromApi(); // Load employees from API on initialization
  }

  // Method to fetch employees from API
  void fetchEmployeesFromApi() async {
    try {
      List<dynamic> employees = await ApiService.fetchEmployees();
      setState(() {
        filteredEmployees = employees.map((employee) {
          // Handle null values gracefully
          return {
            'name': employee['tennv'] != null ? employee['tennv'] as String : '',
            'position': employee['chucvu'] != null ? employee['chucvu'] as String : '',
            'department': employee['tenpb'] != null ? employee['tenpb'] as String : '',
            'iddepartment': employee['mapb'] != null ? employee['mapb'].toString() : '',
            'email': employee['email'] != null ? employee['email'] as String : '',
            'phone': employee['sdt'] != null ? employee['sdt'].toString() : '',
            'address': employee['diachi'] != null ? employee['diachi'] as String : '',
          };
        }).toList();

        // Set original employees for filtering
        _originalEmployees = List<Map<String, String>>.from(filteredEmployees);
      });
    } catch (e) {
      print('Error fetching employees: $e');
      // Handle error loading employees from API
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filterEmployees();
    });
  }

  void updateSelectedDepartment(int? newDepartmentMapb) {
    setState(() {
      selectedDepartmentMapb = newDepartmentMapb;
      filterEmployees();
    });
  }

  List<Map<String, String>> _originalEmployees = []; // Define _originalEmployees as a class member

  void filterEmployees() {
    setState(() {
      filteredEmployees = _originalEmployees.where((employee) {
        final matchesSearchQuery = employee['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final matchesDepartment = selectedDepartmentMapb == null ||
            (selectedDepartmentMapb == 0 || // Handle 'Tất cả' case where value is null or 0
                employee['iddepartment'] == selectedDepartmentMapb.toString());
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
                PopupMenuButton<int>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (int? value) {
                    updateSelectedDepartment(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      {'label': 'Tất cả', 'value': 0},
                      {'label': 'Phòng Nhân sự', 'value': 1},
                      {'label': 'Phòng Marketing', 'value': 2},
                      {'label': 'Phòng Kế toán - Tài chính', 'value': 3},
                      {'label': 'Phòng Hành chính', 'value': 4},
                      {'label': 'Phòng Kỹ thuật', 'value': 5},
                      {'label': 'Phòng Đảm bảo chất lượng', 'value': 6},
                    ].map((item) {
                      return PopupMenuItem<int>(
                        value: item['value'] as int?,
                        child: Text(item['label'] as String),
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
                            employee: filteredEmployees[index],
                          ),
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
