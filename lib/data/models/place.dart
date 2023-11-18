// ignore_for_file: public_member_api_docs, sort_constructors_first
class Place {
  String? name;
  int? code;
  String? divisionType;
  String? codeName;
  int? phoneCode;

  Place({
    this.name,
    this.code,
    this.divisionType,
    this.codeName,
    this.phoneCode,
  });

  Place.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    divisionType = json['division_type'];
    codeName = json['codename'];
    phoneCode = json['phone_code'];
  }
}
