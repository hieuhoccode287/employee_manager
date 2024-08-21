import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/utils/constants.dart';

class DepartmentManagementPage extends StatefulWidget {
  @override
  _DepartmentManagementPageState createState() => _DepartmentManagementPageState();
}

class _DepartmentManagementPageState extends State<DepartmentManagementPage> {
  Future<List<Map<String, dynamic>>>? _departments;
  String _newDepartmentName = '';

  @override
  void initState() {
    super.initState();
    _departments = ApiService.fetchDepartments(); // Gọi API để lấy danh sách phòng ban
  }

  void _editDepartment(Map<String, dynamic> department) {
    String editedName = department['tenpb'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa phòng ban'),
        content: TextField(
          controller: TextEditingController(text: editedName),
          decoration: InputDecoration(labelText: 'Tên phòng ban'),
          onChanged: (value) {
            editedName = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Lưu'),
            onPressed: () {
              if (editedName.isNotEmpty) {
                ApiService.editDepartment(
                  id: department['mapb'],
                  tenpb: editedName,
                ).then((_) {
                  setState(() {
                    _departments = ApiService.fetchDepartments();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cập nhật phòng ban thành công.')),
                  );
                }).catchError((error) {
                  print('Error editing department: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cập nhật phòng ban thất bại.')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tên phòng ban không được để trống.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteDepartment(Map<String, dynamic> department) {
    final departmentId = department['mapb'];
    if (departmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID phòng ban không hợp lệ.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa phòng ban'),
        content: Text('Bạn có chắc chắn muốn xóa phòng ban "${department['tenpb']}"?'),
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
              ApiService.deleteDepartment(departmentId).then((_) {
                setState(() {
                  _departments = ApiService.fetchDepartments();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xóa phòng ban thành công.')),
                );
              }).catchError((error) {
                print('Error deleting department: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xóa phòng ban thất bại.')),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _addDepartment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm phòng ban'),
        content: TextField(
          decoration: InputDecoration(labelText: 'Tên phòng ban'),
          onChanged: (value) {
            _newDepartmentName = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Thêm'),
            onPressed: () {
              if (_newDepartmentName.isNotEmpty) {
                ApiService.addDepartment(_newDepartmentName).then((_) {
                  setState(() {
                    _departments = ApiService.fetchDepartments();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thêm phòng ban thành công.')),
                  );
                }).catchError((error) {
                  print('Error adding department: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thêm phòng ban thất bại.')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng nhập tên phòng ban.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý phòng ban',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, size: 30.0, color: Colors.white),
            onPressed: _addDepartment,
            tooltip: 'Thêm phòng ban', // Thêm tooltip để người dùng biết chức năng của nút
          ),
        ],

      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _departments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phòng ban nào.'));
          } else {
            return SingleChildScrollView(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true, // Thêm shrinkWrap: true để giải quyết overflow
                physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn của GridView
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final department = snapshot.data![index];
                  return Card(
                    elevation: 4.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Icon(Icons.business, size: 50.0, color: Colors.green),
                        ),
                        Expanded(
                          child: Text(
                            department['tenpb'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _editDepartment(department),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0), // Thêm padding để tăng vùng nhấn
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        Text('Sửa', style: TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _deleteDepartment(department),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        Text('Xóa', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
