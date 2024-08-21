import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'package:employee_manager/screens/performance_management_page.dart';
import 'package:employee_manager/api/api_service.dart';
import 'competency_profile_page.dart';
import 'department_management_page.dart'; // Import DepartmentManagementPage

class HomePage extends StatefulWidget {
  final String email;

  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      String fetchedName = await ApiService.fetchUserName(widget.email);
      setState(() {
        name = fetchedName;
      });
    } catch (e) {
      print('Failed to fetch user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            Text(
              ' Xin chào, $name!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: <Widget>[
          _buildSmallCard(
            icon: Icons.access_time,
            title: 'Theo dõi thời gian\nvà điểm danh',
            color: Colors.blue,
            onTap: () {
              // Navigate to time tracking page
            },
          ),
          _buildSmallCard(
            icon: Icons.trending_up,
            title: 'Quản lý\nhiệu suất',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformanceManagementPage(),
                ),
              );
            },
          ),
          _buildSmallCard(
            icon: Icons.folder_shared,
            title: 'Quản lý hồ sơ\nnăng lực',
            color: Colors.brown,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompetencyProfilePage(),
                ),
              );
            },
          ),
          _buildSmallCard(
            icon: Icons.business,
            title: 'Quản lý phòng ban',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepartmentManagementPage(),
                ),
              );
            },
          ),
          _buildSmallCard(
            icon: Icons.school,
            title: 'Đào tạo và\nphát triển',
            color: Colors.purple,
            onTap: () {
              // Navigate to training and development page
            },
          ),
          _buildSmallCard(
            icon: Icons.attach_money,
            title: 'Quản lý tiền lương\nvà phúc lợi',
            color: Colors.red,
            onTap: () {
              // Navigate to salary and benefits management page
            },
          ),
          _buildSmallCard(
            icon: Icons.insert_chart,
            title: 'Phân tích và\nbáo cáo',
            color: Colors.teal,
            onTap: () {
              // Navigate to analysis and reporting page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({required IconData icon, required String title, required Color color, VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: color,
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
