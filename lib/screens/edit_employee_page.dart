
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/utils/constants.dart';

class EditEmployeePage extends StatefulWidget {
  final int employeeId;

  const EditEmployeePage({required this.employeeId});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  int _selectedDepartmentId = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  File? _image;
  String _avatarUrl = '';

  List<Map<String, dynamic>> _departments = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
    fetchDepartments();
  }

  Future<void> fetchEmployeeDetails() async {
    try {
      Map<String, dynamic> employee = await ApiService.fetchEmployeeDetails(widget.employeeId);
      setState(() {
        _nameController.text = employee['tennv'] ?? '';
        _positionController.text = employee['chucvu'] ?? '';
        _selectedDepartmentId = employee['mapb'] ?? 0;
        _emailController.text = employee['email'] ?? '';
        _phoneController.text = employee['sdt'].toString() ?? '';
        _addressController.text = employee['diachi'] ?? '';
        _avatarUrl = employee['avatar_url'] ?? '';
      });
    } catch (e) {
      print('Error fetching employee details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải thông tin nhân viên'),
        ),
      );
    }
  }

  Future<String> _fetchAvatarUrl() async {
    // Fetch the image URL based on _avatarUrl which is a filename or a full URL
    if (_avatarUrl.isNotEmpty) {
      return ApiService.getImageUrl(_avatarUrl);
    } else {
      String name = _nameController.text.isNotEmpty ? _nameController.text : ' ';
      return 'https://ui-avatars.com/api/?name=$name&size=128';
    }
  }

  Future<void> fetchDepartments() async {
    try {
      List<Map<String, dynamic>> departments = await ApiService.fetchDepartments();
      setState(() {
        _departments = departments;
        if (_departments.isNotEmpty) {
          _selectedDepartmentId = _departments.firstWhere((dept) => dept['mapb'] == _selectedDepartmentId, orElse: () => _departments[0])['mapb'];
        }
      });
    } catch (e) {
      print('Error fetching departments: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải danh sách phòng ban'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedDepartmentId,
      decoration: InputDecoration(
        labelText: 'Phòng ban',
        prefixIcon: Icon(Icons.business),
        border: OutlineInputBorder(),
      ),
      items: _departments.map((dept) => DropdownMenuItem<int>(
        value: dept['mapb'],
        child: Text(dept['tenpb']),
      )).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDepartmentId = value!;
        });
      },
      validator: (value) {
        if (value == null || value == 0) {
          return 'Vui lòng chọn phòng ban';
        }
        return null;
      },
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          FutureBuilder<String>(
            future: _fetchAvatarUrl(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.error, color: Colors.red),
                );
              } else {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(snapshot.data ?? ''),
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _saveEmployeeChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;
        if (_image != null) {
          imageUrl = await ApiService.uploadImage(_image!);
        }

        Map<String, dynamic> updatedEmployee = {
          'id': widget.employeeId,
          'tennv': _nameController.text.trim(),
          'chucvu': _positionController.text.trim(),
          'mapb': _selectedDepartmentId,
          'email': _emailController.text.trim(),
          'sdt': _phoneController.text.trim(),
          'diachi': _addressController.text.trim(),
          'avatar_url': imageUrl ?? _avatarUrl,
        };

        Map<String, dynamic> result = await ApiService.updateEmployee(updatedEmployee);

        if (result.containsKey('success') && result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thông tin nhân viên đã được cập nhật'),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          throw Exception('Failed to update employee');
        }
      } catch (e) {
        print('Error updating employee: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra khi cập nhật thông tin nhân viên'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa nhân viên',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên nhân viên'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên nhân viên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Chức vụ'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập chức vụ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildDepartmentDropdown(),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Vui lòng nhập email hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Vui lòng nhập số điện thoại hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEmployeeChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Makes button wider
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Adds vertical padding
                    textStyle: TextStyle(fontSize: 18), // Increases font size
                  ),
                  child: Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
