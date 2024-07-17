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
  String searchQuery = '';
  int? selectedDepartmentMapb;

  @override
  void initState() {
    super.initState();
    fetchEmployeesFromApi(); // Load employees from API on initialization
  }

  void fetchEmployeesFromApi() async {
    try {
      List<dynamic> employees = await ApiService.fetchEmployees();
      setState(() {
        _originalEmployees = employees.map((employee) {
          String avatarUrl = employee['avatar_url'] != null && employee['avatar_url'].isNotEmpty
              ? 'http://192.168.1.5:3000${employee['avatar_url']}'
              : '';
          // Log the URL for debugging
          print('Avatar URL: $avatarUrl');

          return {
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

        // Check if selectedDepartmentMapb is null or matches the employee's department
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
                final avatarUrl = filteredEmployees[index]['url']!;
                return Card(
                  child: ListTile(
                    title: Text(filteredEmployees[index]['name']!),
                    subtitle: Text(filteredEmployees[index]['position']!),
                    leading: CircleAvatar(
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : AssetImage('assets/placeholder.png'), // Placeholder image
                      onBackgroundImageError: (_, __) {
                        // Defer the setState to a safe point using addPostFrameCallback
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          setState(() {
                            // Do not reset the URL here, only mark as empty if needed
                            if (filteredEmployees[index]['url'] == avatarUrl) {
                              filteredEmployees[index]['url'] = ''; // Remove broken URL
                            }
                          });
                        });
                      },
                      child: avatarUrl.isEmpty
                          ? Text(
                        filteredEmployees[index]['name']![0],
                        style: TextStyle(color: Colors.white),
                      )
                          : null,
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeePage(),
            ),
          );

          if (result == true) {
            fetchEmployeesFromApi(); // Refresh the employee list
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
