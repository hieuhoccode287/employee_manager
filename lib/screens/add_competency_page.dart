import 'package:flutter/material.dart';
import 'package:employee_manager/utils/constants.dart';

class AddCompetencyPage extends StatefulWidget {
  @override
  _AddCompetencyPageState createState() => _AddCompetencyPageState();
}

class _AddCompetencyPageState extends State<AddCompetencyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedDepartment;
  String? selectedEmployee;
  String skills = '';
  String experience = '';
  String education = '';
  String certifications = '';
  String projects = '';

  final List<String> departments = [
    'Phòng IT',
    'Phòng Marketing',
    'Phòng Nhân sự',
  ];

  final Map<String, List<String>> employeesByDepartment = {
    'Phòng IT': ['John Doe', 'Emily Davis'],
    'Phòng Marketing': ['Jane Smith'],
    'Phòng Nhân sự': ['Alice Johnson', 'Bob Brown'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm năng lực',
          style: TextStyle(
            color: Colors.white, // Text color of the title
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Chọn phòng ban',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDepartment,
                  items: departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDepartment = newValue;
                      selectedEmployee = null; // Reset selected employee
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn phòng ban' : null,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Chọn nhân viên',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedEmployee,
                  items: selectedDepartment == null
                      ? []
                      : employeesByDepartment[selectedDepartment!]!
                      .map((String employee) {
                    return DropdownMenuItem<String>(
                      value: employee,
                      child: Text(employee),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEmployee = newValue;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn nhân viên' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập kỹ năng',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      skills = value;
                    });
                  },
                  validator: (value) => value!.isEmpty
                      ? 'Vui lòng nhập kỹ năng năng lực'
                      : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập kinh nghiệm',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      experience = value;
                    });
                  },
                  validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập kinh nghiệm' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập học vấn',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      education = value;
                    });
                  },
                  validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập học vấn' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập chứng chỉ',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      certifications = value;
                    });
                  },
                  validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập chứng chỉ' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập dự án',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      projects = value;
                    });
                  },
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập dự án' : null,
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Set width to full screen width
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Xử lý khi form hợp lệ
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Thêm năng lực thành công')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Thêm năng lực'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0), // Vertical padding
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
