part of 'detail_attribute_bloc.dart';

abstract class DetailAttributeState extends Equatable {
  const DetailAttributeState();

  @override
  List<Object> get props => [];
}

class DetailAttributeInitital extends DetailAttributeState {}

class DetailAttributeLoading extends DetailAttributeState {}

class DetailAttributeError extends DetailAttributeState {
  final String errorMessage;

  const DetailAttributeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class DetailAttributeLoaded extends DetailAttributeState {
  final AttributeValueDataSourceAsync attributesDataSource;
  final bool? isAdded;
  const DetailAttributeLoaded(this.attributesDataSource, this.isAdded);

  @override
  List<Object> get props => [attributesDataSource];
}
