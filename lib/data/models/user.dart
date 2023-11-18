// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String? avatar;
  final String? mail;
  final String? password;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? phoneNum;
  User({
    this.avatar,
    this.mail,
    this.password,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.phoneNum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'avatar': avatar,
      'email': mail,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'phoneNum': phoneNum,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      avatar: map['avatar'] != null ? map['avatar'] as String : 'Unknowned',
      mail: map['mail'] != null ? map['mail'] as String : 'Unknowned',
      password:
          map['password'] != null ? map['password'] as String : 'Unknowned',
      firstName:
          map['firstName'] != null ? map['firstName'] as String : 'Unknowned',
      lastName:
          map['lastName'] != null ? map['lastName'] as String : 'Unknowned',
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int)
          : null,
      phoneNum:
          map['phoneNum'] != null ? map['phoneNum'] as String : 'Unknowned',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? avatar,
    String? mail,
    String? password,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? phoneNum,
  }) {
    return User(
      avatar: avatar ?? this.avatar,
      mail: mail ?? this.mail,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}
