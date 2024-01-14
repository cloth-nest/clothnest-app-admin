// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_staff_bloc.dart';

abstract class DetailStaffEvent extends Equatable {
  const DetailStaffEvent();

  @override
  List<Object> get props => [];
}

class DetailStaffStarted extends DetailStaffEvent {
  final int idStaff;
  const DetailStaffStarted({
    required this.idStaff,
  });
}
