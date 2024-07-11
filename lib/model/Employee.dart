class Employee {
  final String name;
  final String position;
  final String department;
  final String email;
  final String phone;
  final String address;
  final List<Competency> competencies;

  Employee({
    required this.name,
    required this.position,
    required this.department,
    required this.email,
    required this.phone,
    required this.address,
    required this.competencies,
  });
}

class Competency {
  final String name;
  int level;

  Competency({
    required this.name,
    required this.level,
  });
}
