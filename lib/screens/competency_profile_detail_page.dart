import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/utils/constants.dart';

class CompetencyProfileDetailPage extends StatefulWidget {
  final int employeeId;

  const CompetencyProfileDetailPage({required this.employeeId});

  @override
  _CompetencyProfileDetailPageState createState() => _CompetencyProfileDetailPageState();
}

class _CompetencyProfileDetailPageState extends State<CompetencyProfileDetailPage> {
  Map<String, dynamic>? employee;
  Map<String, dynamic>? competency;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
  }

  void fetchEmployeeDetails() async {
    try {
      // Fetch basic employee details
      final details = await ApiService.fetchEmployeeDetails(widget.employeeId);
      setState(() {
        employee = details;
        // Fetch competency details using manl from the employee data
        if (employee != null && employee!['manl'] != null) {
          fetchCompetencyDetails(employee!['manl']);
        } else {
          isLoading = false;
        }
      });
    } catch (e) {
      print('Error fetching employee details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchCompetencyDetails(int manl) async {
    try {
      final details = await ApiService.fetchCompetencyById(manl);
      setState(() {
        competency = details;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching competency details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          employee?['tennv'] ?? 'Chi tiết Nhân viên',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployeeCompentency(context);
              } else if (value == 'delete') {
                _deleteEmployee(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Sửa'),
                ),
              ),
              const PopupMenuDivider(
                height: 1,
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Xóa'),
                ),
              ),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: employee?['avatar_url'] != null && employee?['avatar_url'].isNotEmpty
                            ? NetworkImage('http://192.168.1.5:3000${employee!['avatar_url']}')
                            : NetworkImage('https://ui-avatars.com/api/?name=${employee?['tennv']}&size=128'),
                        onBackgroundImageError: (_, __) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            setState(() {
                              // Use placeholder image if the network image fails to load
                              if (employee?['avatar_url'] != null) {
                                employee!['avatar_url'] = '';
                              }
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tên:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee?['tennv'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chức vụ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee?['chucvu'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kỹ năng:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      competency?['kynang'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kinh nghiệm:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      competency?['kinhnghiem'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Học vấn:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      competency?['hocvan'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chứng chỉ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      competency?['chungchi'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dự án:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      competency?['duan'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editEmployeeCompentency(BuildContext context) {
    // Implement edit functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng Sửa đang được phát triển')),
    );
  }

  void _deleteEmployee(BuildContext context) {
    // Implement delete functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng Xóa đang được phát triển')),
    );
  }
}
