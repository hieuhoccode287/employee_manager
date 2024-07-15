import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'competency_profile_detail_page.dart';
import 'add_competency_page.dart';

class CompetencyProfilePage extends StatefulWidget {
  @override
  _CompetencyProfilePageState createState() => _CompetencyProfilePageState();
}

class _CompetencyProfilePageState extends State<CompetencyProfilePage> {
  final List<Map<String, String>> employees = [
    {
      'name': 'John Doe',
      'position': 'Kỹ sư phần mềm',
      'department': 'Kỹ thuật',
      'skills': 'Lập trình Flutter, Quản lý dự án',
      'experience': '3 năm kinh nghiệm trong lĩnh vực phát triển phần mềm.',
      'education': 'Cử nhân Khoa học Máy tính tại Đại học ABC',
      'certifications': 'Chứng chỉ PMP, Chứng chỉ AWS',
      'projects': 'Dự án A, Dự án B',
    },
    {
      'name': 'Jane Smith',
      'position': 'Quản lý sản phẩm',
      'department': 'Quản lý sản phẩm',
      'skills': 'Digital Marketing, Content Creation',
      'experience': '2 năm kinh nghiệm trong lĩnh vực marketing.',
      'education': 'Cử nhân Quản trị Kinh doanh tại Đại học XYZ',
      'certifications': 'Chứng chỉ Google Analytics, Chứng chỉ SEO',
      'projects': 'Dự án C, Dự án D',
    },
    {
      'name': 'Emily Davis',
      'position': 'Chuyên viên Phân tích dữ liệu',
      'department': 'Dữ liệu',
      'skills': 'Data Analysis, Python, SQL',
      'experience': '2 years as Data Analyst at ABC Corporation',
      'education': 'Master\'s in Data Science from DEF University',
      'certifications': 'Certified Data Scientist, Certified Python Programmer',
      'projects': 'Project E, Project F',
    }
    // Add more employee data as needed
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
    filteredEmployees = employees.where((employee) {
      final matchesSearchQuery = employee['name']!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesDepartment = selectedDepartment == 'Tất cả' ||
          (employee['department'] != null &&
              employee['department']!.toLowerCase() == selectedDepartment.toLowerCase());
      return matchesSearchQuery && matchesDepartment;
    }).toList();
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
                          builder: (context) => CompetencyProfileDetailPage(
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
              builder: (context) => AddCompetencyPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
