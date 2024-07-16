import 'package:flutter/material.dart';
import 'package:employee_manager/screens/performance_detail_page.dart';
import 'package:employee_manager/utils/constants.dart';

class PerformanceManagementPage extends StatelessWidget {
  final List<Map<String, dynamic>> performanceData = [
    {
      'employeeName': 'Nguyễn Văn A',
      'month': '8',
      'revenue': 5000,
      'rating': 4.5,
      'goal': '10,000\$',
      'detail': 'Chi tiết về hiệu suất của Nhân viên Nguyễn Văn A trong tháng 8.',
    },
    {
      'employeeName': 'Trần Thị B',
      'month': '7',
      'revenue': 7000,
      'rating': 4.2,
      'goal': '12,000\$',
      'detail': 'Chi tiết về hiệu suất của Nhân viên Trần Thị B trong tháng 7.',
    },
    {
      'employeeName': 'Hoàng Đức C',
      'month': '7',
      'revenue': 4000,
      'rating': 4.8,
      'goal': '8,000\$',
      'detail': 'Chi tiết về hiệu suất của Nhân viên Hoàng Đức C trong tháng 7.',
    },
    // Add more performance data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Quản lý hiệu suất',
          style: TextStyle(
            color: Colors.white, // Text color of the title
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: performanceData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Navigate to a detailed view page passing performanceData[index]
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformanceDetailPage(data: performanceData[index]),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('path_to_your_image'), // Replace with your image path
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            performanceData[index]['employeeName'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('Tháng: ${performanceData[index]['month']}'),
                        ],
                      ),
                    ),
                    Text(
                      '${performanceData[index]['rating']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
