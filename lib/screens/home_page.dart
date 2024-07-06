import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class HomePage extends StatelessWidget {
  final String name = "Guest"; // Đổi tên người dùng ở đây

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

  Widget _buildSmallCard({required IconData icon, required String title, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
    );
  }
}
