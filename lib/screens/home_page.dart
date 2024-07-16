
import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';
import 'package:employee_manager/api/api_service.dart'; // Import the ApiService
import 'competency_profile_page.dart';

class HomePage extends StatefulWidget {
  final String email; // Declare the email as final

  // Constructor for HomePage
  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = ""; // Initial placeholder

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
      // Handle the error appropriately, possibly show an error message
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
                color: Colors.white, // Màu chữ của tiêu đề
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              // TODO: Navigate to settings screen
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
          ),
          _buildSmallCard(
            icon: Icons.people,
            title: 'Tuyển dụng và\ntheo dõi ứng viên',
            color: Colors.green,
          ),
          _buildSmallCard(
            icon: Icons.trending_up,
            title: 'Quản lý\nhiệu suất',
            color: Colors.orange,
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
            icon: Icons.school,
            title: 'Đào tạo và\nphát triển',
            color: Colors.purple,
          ),
          _buildSmallCard(
            icon: Icons.attach_money,
            title: 'Quản lý tiền lương\nvà phúc lợi',
            color: Colors.red,
          ),
          _buildSmallCard(
            icon: Icons.insert_chart,
            title: 'Phân tích và\nbáo cáo',
            color: Colors.teal,
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
                color: color, // Màu sắc của biểu tượng
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold), // Màu sắc của tiêu đề
              ),
            ],
          ),
        ),
      ),
    );
  }
}
