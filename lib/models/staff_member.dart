class StaffMember {
  String? id;
  final String name;
  final String qualification;
  final String department;
  final String subDepartment;
  final String experience;
  final String address;
  final String contactNo;

  StaffMember(
      {required this.name,
      required this.qualification,
      required this.department,
      required this.subDepartment,
      required this.experience,
      required this.address,
      required this.contactNo});

  Map<String, dynamic> toMap() {
    return {
      'name': name.toUpperCase(),
      'qualification': qualification,
      'department': department,
      'experience': experience,
      'subDepartment': subDepartment,
      'address': address,
      'contactNo': contactNo
    };
  }

  factory StaffMember.fromMap(Map<String, dynamic> data) {
    return StaffMember(
        name: data['name'],
        qualification: data['qualification'],
        department: data['department'],
        subDepartment: data['subDepartment'],
        experience: data['experience'],
        address: data['address'],
        contactNo: data['contactNo']);
  }

  @override
  String toString() => toMap().toString();
}
