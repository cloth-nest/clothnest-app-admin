// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_product_type_bloc.dart';

abstract class DetailProductTypeState extends Equatable {
  const DetailProductTypeState();

  @override
  List<Object> get props => [];
}

class DetailProductTypeInitial extends DetailProductTypeState {
  final List<ProductType> productAttributes;
  final List<ProductType> variantAttributes;
  const DetailProductTypeInitial({
    required this.productAttributes,
    required this.variantAttributes,
  });
}

class DetailProductTypeLoading extends DetailProductTypeState {}

class DetailProductTypeAdded extends DetailProductTypeState {}
