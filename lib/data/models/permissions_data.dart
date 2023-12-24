import 'package:grocery/data/models/page_information.dart';
import 'package:grocery/data/models/permission.dart';

class PermissionsData {
  final List<Permission> permissions;
  final PageInformation pageInformation;

  PermissionsData({
    required this.permissions,
    required this.pageInformation,
  });

  factory PermissionsData.fromMap(Map<String, dynamic> map) {
    return PermissionsData(
      permissions: List<Permission>.from(
        (map['groupPermissions']).map<Permission>(
          (x) => Permission.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
