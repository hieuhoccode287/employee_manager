import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedDepartment = 'Kỹ thuật'; // Default department

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
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
            color: Colors.white, // Text color of the title
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Color of the back button
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
              _buildTextField('Email', _emailController, Icons.email),
              SizedBox(height: 16.0),
              _buildTextField('Số điện thoại', _phoneController, Icons.phone),
              SizedBox(height: 16.0),
              _buildTextField('Địa chỉ', _addressController, Icons.home, maxLines: 3),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveEmployee();
                    Navigator.pop(context);
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
            child: Icon(
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
                onPressed: () {
                  // Implement image upload functionality
                },
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
      items: ['Kỹ thuật', 'Quản lý', 'Thiết kế', 'Dữ liệu', 'Đảm bảo chất lượng']
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

  void _saveEmployee() {
    // Save employee data implementation
    print('Employee Name: ${_nameController.text}');
    print('Position: ${_positionController.text}');
    print('Department: $_selectedDepartment');
    print('Email: ${_emailController.text}');
    print('Phone: ${_phoneController.text}');
    print('Address: ${_addressController.text}');
  }
}
