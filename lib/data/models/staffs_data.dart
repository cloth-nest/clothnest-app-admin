import 'package:grocery/data/models/page_information.dart';
import 'package:grocery/data/models/staff.dart';

class StaffsData {
  final List<Staff> staffs;
  final PageInformation pageInformation;
  StaffsData({
    required this.staffs,
    required this.pageInformation,
  });

  factory StaffsData.fromMap(Map<String, dynamic> map) {
    return StaffsData(
      staffs: List<Staff>.from(
        (map['staffMembers']).map<Staff>(
          (x) => Staff.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
