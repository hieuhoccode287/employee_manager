import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';
import 'package:employee_manager/utils/constants.dart';

class EditCompetencyPage extends StatefulWidget {
  final Map<String, dynamic> employee;

  const EditCompetencyPage({required this.employee});

  @override
  _EditCompetencyPageState createState() => _EditCompetencyPageState();
}

class _EditCompetencyPageState extends State<EditCompetencyPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _skillsController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;
  late TextEditingController _certificationsController;
  late TextEditingController _projectsController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _skillsController = TextEditingController();
    _experienceController = TextEditingController();
    _educationController = TextEditingController();
    _certificationsController = TextEditingController();
    _projectsController = TextEditingController();

    fetchCompetencyDetails(widget.employee['manl']);
  }

  @override
  void dispose() {
    _skillsController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _certificationsController.dispose();
    _projectsController.dispose();
    super.dispose();
  }

  void fetchCompetencyDetails(int manl) async {
    try {
      final details = await ApiService.fetchCompetencyById(manl);
      setState(() {
        _skillsController.text = details['kynang'] ?? '';
        _experienceController.text = details['kinhnghiem'] ?? '';
        _educationController.text = details['hocvan'] ?? '';
        _certificationsController.text = details['chungchi'] ?? '';
        _projectsController.text = details['duan'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching competency details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _saveCompetency() async {
    if (_formKey.currentState!.validate()) {
      final updatedCompetency = {
        'kynang': _skillsController.text,
        'kinhnghiem': _experienceController.text,
        'hocvan': _educationController.text,
        'chungchi': _certificationsController.text,
        'duan': _projectsController.text,
      };

      try {
        final manl = widget.employee['manl'] as int? ?? 0;
        await ApiService.updateCompetency(manl, updatedCompetency);

        // Show a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật năng lực thành công')),
        );

        Navigator.pop(context, updatedCompetency);
      } catch (e) {
        print('Error updating employee competency: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update competency')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa năng lực',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.employee['tennv'],
                decoration: InputDecoration(
                  labelText: 'Tên',
                  prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                ),
                enabled: false,
              ),
              TextFormField(
                initialValue: widget.employee['chucvu'],
                decoration: InputDecoration(
                  labelText: 'Chức vụ',
                  prefixIcon: Icon(Icons.work, color: Colors.grey[600]),
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _skillsController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Kỹ năng',
                  prefixIcon: Icon(Icons.star),
                ),
              ),
              TextFormField(
                controller: _experienceController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Kinh nghiệm',
                  prefixIcon: Icon(Icons.history),
                ),
              ),
              TextFormField(
                controller: _educationController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Học vấn',
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              TextFormField(
                controller: _certificationsController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Chứng chỉ',
                  prefixIcon: Icon(Icons.card_giftcard), // Thay thế cho 'certificate'
                ),
              ),
              TextFormField(
                controller: _projectsController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Dự án',
                  prefixIcon: Icon(Icons.business_center), // Thay thế cho 'project'
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCompetency,
                child: Text('Lưu thay đổi'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Makes button wider
                  padding: EdgeInsets.symmetric(vertical: 10.0), // Adds vertical padding
                  textStyle: TextStyle(fontSize: 18), // Increases font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
