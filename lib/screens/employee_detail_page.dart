import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/screens/edit_employee_page.dart';
import 'package:employee_manager/utils/constants.dart';

class EmployeeDetailPage extends StatefulWidget {
  final int employeeId; // Chuyển đổi thành employeeId để lấy dữ liệu theo ID
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EmployeeDetailPage({
    required this.employeeId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  late Map<String, dynamic> employee;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Map<int, String> departments = {}; // Cache department names

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch employee details
      final employeeData = await ApiService.fetchEmployeeDetails(widget.employeeId);

      // Fetch departments
      final departmentList = await ApiService.fetchDepartments();
      departments = {
        for (var dept in departmentList) dept['mapb']: dept['tenpb']
      };

      setState(() {
        employee = employeeData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Không thể tải thông tin nhân viên.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chi tiết Nhân viên'),
          backgroundColor: primaryColor,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chi tiết Nhân viên'),
          backgroundColor: primaryColor,
        ),
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          employee['tennv'] ?? 'Chi tiết Nhân viên',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployee(context);
              } else if (value == 'delete') {
                _confirmDelete(context);
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
              const PopupMenuDivider(height: 1),
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
      body: SingleChildScrollView(
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
                        backgroundImage: _buildAvatarImage(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tên:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['tennv'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chức vụ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee['chucvu'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
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
                      child: Text(
                        'Chi tiết',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildDetailItem('Phòng ban', _getDepartmentName(employee['mapb'])),
                    buildDetailItem('Email', employee['email'] ?? 'Không rõ'),
                    buildDetailItem('Điện thoại', employee['sdt']?.toString() ?? 'Không rõ'),
                    buildDetailItem('Địa chỉ', employee['diachi'] ?? 'Không rõ'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDepartmentName(int? mapb) {
    return departments[mapb] ?? 'Không rõ';
  }

  Widget buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildAvatarImage() {
    if (employee['avatar_url'] != null && employee['avatar_url'].isNotEmpty) {
      return NetworkImage(ApiService.getImageUrl(employee['avatar_url']));
    } else {
      String name = employee['tennv'] ?? '';
      return NetworkImage('https://ui-avatars.com/api/?name=$name&size=128');
    }
  }

  void _editEmployee(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeePage(employeeId: widget.employeeId),
      ),
    );

    if (result != null && result as bool) {
      // Gọi lại hàm _fetchEmployeeDetails để làm mới thông tin nhân viên
      _fetchData();
      widget.onEdit();
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa nhân viên này?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _deleteEmployee(context);
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(BuildContext context) async {
    try {
      print('Đang xóa nhân viên với ID: ${widget.employeeId}');

      // Fetch employee details to get the competencies
      final employeeData = await ApiService.fetchEmployeeDetails(widget.employeeId);

      // Ensure competencies is a list
      List<dynamic> competencies = employeeData['nangluc'] ?? [];

      // Check if competencies is actually a list
      if (competencies is! List) {
        throw Exception('Dữ liệu năng lực không hợp lệ');
      }

      // Delete each competency and ensure they are successfully deleted
      for (var competency in competencies) {
        final manl = competency['manl']; // Assuming `manl` is the competency ID
        final deleteResult = await ApiService.deleteCompetency(manl);

        // Check if deletion was successful
        if (!deleteResult['success']) {
          throw Exception('Không thể xóa năng lực với ID: $manl. Lỗi: ${deleteResult['error']}');
        }
      }

      // After deleting all competencies, delete the employee
      final deleteEmployeeResult = await ApiService.deleteEmployee(widget.employeeId);

      // Confirm deletion result from server
      if (deleteEmployeeResult.containsKey('success') && deleteEmployeeResult['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nhân viên đã được xóa thành công')),
        );

        // Call the onDelete callback to refresh employee list
        widget.onDelete();

        // Navigate back to the previous page or perform any necessary updates
        Navigator.of(context).pop(); // Close the EmployeeDetailPage
      } else {
        throw Exception('Không thể xóa nhân viên');
      }
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi xóa nhân viên')),
      );
    }
  }



}
