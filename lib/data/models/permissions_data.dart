import 'package:grocery/data/models/page_information.dart';
import 'package:grocery/data/models/group_permission.dart';

class PermissionsData {
  final List<GroupPermission> permissions;
  final PageInformation pageInformation;

  PermissionsData({
    required this.permissions,
    required this.pageInformation,
  });

  factory PermissionsData.fromMap(Map<String, dynamic> map) {
    return PermissionsData(
      permissions: List<GroupPermission>.from(
        (map['groupPermissions']).map<GroupPermission>(
          (x) => GroupPermission.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
