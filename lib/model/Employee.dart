class Employee {
  int id;
  String name;
  String position;
  int department;
  String email;
  int phone;
  String address;
  String avatarUrl;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });

  // Factory method to convert JSON into Employee object if needed
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['manv'],
      name: json['tennv'],
      position: json['chucvu'],
      department: json['mapb'],
      email: json['email'],
      phone: json['sdt'],
      address: json['diachi'],
      avatarUrl: json['avatar_url'],
    );
  }
}
