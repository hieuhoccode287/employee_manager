import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employee_manager/utils/constants.dart';
import 'package:employee_manager/api/api_service.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedDepartment = 'Nhân sự'; // Default department
  File? _image; // Variable to hold selected image file

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Thêm nhân viên mới',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileImage(),
              SizedBox(height: 20.0),
              _buildTextField('Họ và tên', _nameController, Icons.person),
              SizedBox(height: 16.0),
              _buildTextField('Chức vụ', _positionController, Icons.work),
              SizedBox(height: 16.0),
              _buildDepartmentDropdown(),
              SizedBox(height: 16.0),
              _buildTextField('Email', _emailController, Icons.email, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16.0),
              _buildTextField('Số điện thoại', _phoneController, Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 16.0),
              _buildTextField('Địa chỉ', _addressController, Icons.home, maxLines: 3),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveEmployee();
                  }
                },
                child: Text('Thêm nhân viên', style: TextStyle(fontSize: 18.0)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: _image != null
                ? ClipOval(
              child: Image.file(
                _image!,
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.person,
              size: 80.0,
              color: Colors.grey[400],
            ),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int? maxLines}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDepartment,
      decoration: InputDecoration(
        labelText: 'Phòng ban',
        prefixIcon: Icon(Icons.business),
        border: OutlineInputBorder(),
      ),
      items: ['Nhân sự', 'Marketing', 'Kế toán - Tài chính', 'Hành chính','Kỹ thuật', 'Đảm bảo chất lượng']
          .map((dept) => DropdownMenuItem<String>(
        value: dept,
        child: Text(dept),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedDepartment = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn phòng ban';
        }
        return null;
      },
    );
  }

  void _saveEmployee() async {
    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await ApiService.uploadImage(_image!);
      }

      final result = await ApiService.addEmployee(
        tennv: _nameController.text.trim(),
        chucvu: _positionController.text.trim(),
        mapb: _getDepartmentId(_selectedDepartment),
        email: _emailController.text.trim(),
        sdt: int.tryParse(_phoneController.text.trim()),
        diachi: _addressController.text.trim(),
        avatarUrl: imageUrl ?? '',
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm nhân viên thành công')),
        );
        Navigator.pop(context, true); // Pass true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Đã xảy ra lỗi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi khi thêm nhân viên')),
      );
      print('Error adding employee: $e');
    }
  }

  int _getDepartmentId(String departmentName) {
    switch (departmentName) {
      case 'Nhân sự':
        return 1;
      case 'Marketing':
        return 2;
      case 'Kế toán - Tài chính':
        return 3;
      case 'Hành chính':
        return 4;
      case 'Kỹ thuật':
        return 5;
      case 'Đảm bảo chất lượng':
        return 6;
      default:
        return 1;
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      print('Image path: ${pickedFile.path}');
    } else {
      print('No image selected.');
    }
  }
}
