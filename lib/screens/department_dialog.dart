import 'package:flutter/material.dart';
import 'package:employee_manager/api/api_service.dart';

class DepartmentDialog extends StatefulWidget {
  final Map<String, dynamic>? department;

  DepartmentDialog({this.department});

  @override
  _DepartmentDialogState createState() => _DepartmentDialogState();
}

class _DepartmentDialogState extends State<DepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _departmentName;
  int? _departmentId;

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      _departmentName = widget.department!['tenpb'];
      _departmentId = widget.department!['id']; // Ensure 'id' is available
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        if (widget.department == null) {
          await ApiService.addDepartment(_departmentName!);
        } else {
          if (_departmentId != null) {
            await ApiService.editDepartment(
              id: _departmentId!,
              tenpb: _departmentName!,
            );
          }
        }
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        print('Error: $e');
        // Handle error appropriately in your UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.department == null ? 'Thêm phòng ban' : 'Chỉnh sửa phòng ban'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _departmentName,
          decoration: InputDecoration(labelText: 'Tên phòng ban'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tên phòng ban';
            }
            return null;
          },
          onSaved: (value) => _departmentName = value,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: Text('Save'),
        ),
      ],
    );
  }
}
