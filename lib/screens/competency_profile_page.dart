import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'competency_profile_detail_page.dart';
import 'package:employee_manager/api/api_service.dart';

class CompetencyProfilePage extends StatefulWidget {
  @override
  _CompetencyProfilePageState createState() => _CompetencyProfilePageState();
}

class _CompetencyProfilePageState extends State<CompetencyProfilePage> {
  List<Map<String, String>> filteredEmployees = [];
  List<Map<String, String>> _originalEmployees = [];
  String searchQuery = '';
  int? selectedDepartment;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEmployeesFromApi();
  }

  void fetchEmployeesFromApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> employees = await ApiService.fetchEmployees(); // Use the same method as EmployeeListPage
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching employees: $e');
      // Handle error (e.g., show error message, retry option)
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      filterEmployees();
    });
  }

  void updateSelectedDepartment(int? newDepartment) {
    setState(() {
      selectedDepartment = newDepartment;
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
        final matchesDepartment = selectedDepartment == null ||
            selectedDepartment == 0 || // Handle case when "Tất cả" is selected
            employee['iddepartment'] == selectedDepartment.toString();

        return matchesSearchQuery && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Quản lý hồ sơ năng lực',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (BuildContext context, int index) {
                final employee = filteredEmployees[index];
                return Card(
                  child: ListTile(
                    title: Text(employee['name']!),
                    subtitle: Text(employee['position']!),
                    leading: CircleAvatar(
                      backgroundImage: employee['url']!.isNotEmpty
                          ? NetworkImage(employee['url']!)
                          : NetworkImage('https://ui-avatars.com/api/?name=${employee['name']}&size=128'),
                      onBackgroundImageError: (_, __) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          setState(() {
                            if (employee['url'] == employee['url']) {
                              employee['url'] = '';
                            }
                          });
                        });
                      },
                    ),
                    // Inside CompetencyProfilePage
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompetencyProfileDetailPage(
                            employeeId: int.parse(employee['id']!),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddCompetencyPage(),
      //       ),
      //     );
      //
      //     if (result == true) {
      //       fetchEmployeesFromApi();
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
