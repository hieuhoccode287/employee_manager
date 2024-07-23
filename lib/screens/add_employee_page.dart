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
  List<Map<String, dynamic>> _departments = [];
  int? _selectedDepartmentId;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
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

  Future<void> fetchDepartments() async {
    try {
      List<Map<String, dynamic>> departments = await ApiService.fetchDepartments();
      setState(() {
        _departments = departments;
        if (_departments.isNotEmpty) {
          _selectedDepartmentId = _departments.first['mapb'];
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
              _buildTextField('Họ và tên', _nameController, Icons.person, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ và tên';
                }
                if (value.length < 2) {
                  return 'Họ và tên phải có ít nhất 2 kí tự';
                }
                return null;
              }),
              SizedBox(height: 16.0),
              _buildTextField('Chức vụ', _positionController, Icons.work, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập chức vụ';
                }
                if (value.length < 2) {
                  return 'Chức vụ phải có ít nhất 2 kí tự';
                }
                return null;
              }),
              SizedBox(height: 16.0),
              _buildDepartmentDropdown(),
              SizedBox(height: 16.0),
              _buildTextField('Email', _emailController, Icons.email, keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                  return 'Email không hợp lệ';
                }
                return null;
              }),
              SizedBox(height: 16.0),
              _buildTextField('Số điện thoại', _phoneController, Icons.phone, keyboardType: TextInputType.phone, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                  return 'Số điện thoại phải có 10 hoặc 11 chữ số';
                }
                return null;
              }),
              SizedBox(height: 16.0),
              _buildTextField('Địa chỉ', _addressController, Icons.home, maxLines: 3, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                // Optionally add more constraints for address length
                if (value.length < 5) {
                  return 'Địa chỉ phải có ít nhất 5 kí tự';
                }
                return null;
              }),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveEmployee();
                  }
                },
                child: Text('Thêm mới', style: TextStyle(fontSize: 18.0)),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int? maxLines, FormFieldValidator<String>? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
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

  int _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch ~/ 100000;
  }

  void _saveEmployee() async {
    try {
      String? imageUrl;
      int manl = _generateUniqueId();
      if (_image != null) {
        final imageSize = await _image!.length();
        if (imageSize > 2 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kích thước ảnh vượt quá 2MB')),
          );
          return;
        }
        imageUrl = await ApiService.uploadImage(_image!);
      }

      final phoneNumber = _phoneController.text.trim();
      final parsedPhoneNumber = phoneNumber.isNotEmpty ? int.tryParse(phoneNumber) : null;

      final result = await ApiService.addEmployee(
        tennv: _nameController.text.trim(),
        chucvu: _positionController.text.trim(),
        mapb: _selectedDepartmentId!,
        email: _emailController.text.trim(),
        sdt: parsedPhoneNumber,
        diachi: _addressController.text.trim(),
        avatarUrl: imageUrl ?? '',
        manl: manl,
      );

      if (result['success']) {
        print('Employee added with manl: $manl');
        final competencyResult = await ApiService.addCompetency(
          manl: manl,
          kynang: '', // Replace with actual skill
          kinhnghiem: '', // Replace with actual experience
          hocvan: '', // Replace with actual education
          chungchi: '', // Replace with actual certification
          duan: '', // Replace with actual project
        );

        if (competencyResult['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm nhân viên thành công')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(competencyResult['message'] ?? 'Đã xảy ra lỗi khi thêm năng lực')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Đã xảy ra lỗi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi khi thêm nhân viên')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
