import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'employee_detail_page.dart';
import 'add_employee_page.dart';
import 'package:employee_manager/api/api_service.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Map<String, String>> filteredEmployees = [];
  List<Map<String, String>> _originalEmployees = [];
  List<Map<String, dynamic>> _departments = []; // List to store departments
  String searchQuery = '';
  int? selectedDepartmentMapb;

  @override
  void initState() {
    super.initState();
    fetchEmployeesFromApi();
    fetchDepartmentsFromApi(); // Fetch departments when initializing
  }

  void _refreshEmployeeList() {
    fetchEmployeesFromApi();
  }

  void fetchEmployeesFromApi() async {
    try {
      List<dynamic> employees = await ApiService.fetchEmployees();
      setState(() {
        _originalEmployees = employees.map((employee) {
          String avatarUrl = employee['avatar_url'] != null && employee['avatar_url'].isNotEmpty
              ? ApiService.getImageUrl(employee['avatar_url'])
              : '';
          return {
            'id': employee['manv'] != null ? employee['manv'].toString() : '',
            'name': employee['tennv'] != null ? employee['tennv'] as String : '',
            'position': employee['chucvu'] != null ? employee['chucvu'] as String : '',
            'department': employee['tenpb'] != null ? employee['tenpb'] as String : '',
            'url': avatarUrl,
            'iddepartment': employee['mapb'] != null ? employee['mapb'].toString() : '',
            'email': employee['email'] != null ? employee['email'] as String : '',
            'phone': employee['sdt'] != null ? employee['sdt'].toString() : '',
            'address': employee['diachi'] != null ? employee['diachi'] as String : '',
          };
        }).toList();

        // Initialize filteredEmployees with all employees initially
        filteredEmployees = List<Map<String, String>>.from(_originalEmployees);
      });
    } catch (e) {
      print('Error fetching employees: $e');
      // Handle error (e.g., show error message, retry option)
    }
  }

  void fetchDepartmentsFromApi() async {
    try {
      List<dynamic> departments = await ApiService.fetchDepartments();
      setState(() {
        _departments = departments.map((dept) {
          return {
            'label': dept['tenpb'],
            'value': dept['mapb'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching departments: $e');
      // Handle error (e.g., show error message)
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

  void filterEmployees() {
    setState(() {
      filteredEmployees = _originalEmployees.where((employee) {
        final matchesSearchQuery = employee['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        final matchesDepartment = selectedDepartmentMapb == null ||
            selectedDepartmentMapb == 0 || // Handle case when "Tất cả" is selected
            employee['iddepartment'] == selectedDepartmentMapb.toString();

        return matchesSearchQuery && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: const Text(
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
                      ..._departments, // Add dynamic departments here
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
                final avatarUrl = filteredEmployees[index]['url']!;
                final name = filteredEmployees[index]['name']!;
                final employeeId = int.tryParse(filteredEmployees[index]['id']!);

                return Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(filteredEmployees[index]['position']!),
                    leading: CircleAvatar(
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : NetworkImage('https://ui-avatars.com/api/?name=$name&size=128'),
                      onBackgroundImageError: (_, __) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          setState(() {
                            if (filteredEmployees[index]['url'] == avatarUrl) {
                              filteredEmployees[index]['url'] = '';
                            }
                          });
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeDetailPage(
                            employeeId: employeeId ?? 0,
                            onDelete: () {
                              _refreshEmployeeList();
                            },
                            onEdit: () {
                              _refreshEmployeeList(); // Ensure it refreshes after returning
                            },
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeePage(),
            ),
          );

          if (result == true) {
            fetchEmployeesFromApi();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
