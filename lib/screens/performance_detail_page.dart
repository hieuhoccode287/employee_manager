import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class PerformanceDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  PerformanceDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Chi tiết hiệu suất',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('path_to_your_image'), // Replace with your image path
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['employeeName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Position: ${data['position']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              title: 'Tháng:',
              value: data['month'],
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
            ),
            _buildInfoRow(
              title: 'Doanh thu:',
              value: '${data['revenue']} \$',
              icon: Icons.attach_money,
              iconColor: Colors.green,
            ),
            _buildInfoRow(
              title: 'Mục tiêu:',
              value: '${data['goal']} \$',
              icon: Icons.flag,
              iconColor: Colors.red,
            ),
            _buildInfoRow(
              title: 'Đánh giá:',
              value: '${data['rating']}',
              icon: Icons.star,
              iconColor: Colors.orange,
            ),
            _buildInfoRow(
              title: 'Chi tiết:',
              value: data['detail'], // Display the 'detail' field
              icon: Icons.description,
              iconColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align children to the start
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 5, // Adjust as needed for the number of lines
            ),
          ),
        ],
      ),
    );
  }
}
