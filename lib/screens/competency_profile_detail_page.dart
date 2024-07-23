import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/screens/edit_competency_page.dart';
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
      final details = await ApiService.fetchEmployeeDetails(widget.employeeId);
      setState(() {
        employee = details;
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployeeCompetency(context);
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
                        backgroundImage: employee?['avatar_url'] != null &&
                            employee!['avatar_url'].isNotEmpty
                            ? NetworkImage(ApiService.getImageUrl(employee?['avatar_url']))
                            : NetworkImage('https://ui-avatars.com/api/?name=${employee?['tennv']}&size=128'),
                        onBackgroundImageError: (_, __) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            setState(() {
                              if (employee?['avatar_url'] != null) {
                                employee!['avatar_url'] = '';
                              }
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('Tên:', employee?['tennv'] ?? 'Không rõ'),
                    _buildDetailRow('Chức vụ:', employee?['chucvu'] ?? 'Không rõ'),
                    _buildDetailRow('Kỹ năng:', competency?['kynang'] ?? 'Không rõ'),
                    _buildDetailRow('Kinh nghiệm:', competency?['kinhnghiem'] ?? 'Không rõ'),
                    _buildDetailRow('Học vấn:', competency?['hocvan'] ?? 'Không rõ'),
                    _buildDetailRow('Chứng chỉ:', competency?['chungchi'] ?? 'Không rõ'),
                    _buildDetailRow('Dự án:', competency?['duan'] ?? 'Không rõ'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          content.isNotEmpty ? content : 'Không rõ', // Ensure content is not empty
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 12),
      ],
    );
  }


  void _editEmployeeCompetency(BuildContext context) {
    if (employee != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditCompetencyPage(employee: employee!),
        ),
      ).then((updatedCompetency) {
        if (updatedCompetency != null) {
          setState(() {
            competency = updatedCompetency;
          });
        }
      });
    }
  }
}
