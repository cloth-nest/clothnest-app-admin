// ignore_for_file: public_member_api_docs, sort_constructors_first
class Staff {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool? selected;

  Staff({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isActive': isActive,
      'selected': selected,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as int,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      isActive: map['isActive'] as bool,
    );
  }
}
