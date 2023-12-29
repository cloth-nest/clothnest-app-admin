// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_product_bloc.dart';

abstract class DetailProductState extends Equatable {
  const DetailProductState();

  @override
  List<Object> get props => [];
}

class DetailProductInitial extends DetailProductState {
  final DetailProduct product;
  const DetailProductInitial({
    required this.product,
  });
}

class DetailProductLoading extends DetailProductState {}

class DetailProductFailure extends DetailProductState {}
