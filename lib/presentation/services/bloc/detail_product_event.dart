// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_product_bloc.dart';

abstract class DetailProductEvent extends Equatable {
  const DetailProductEvent();

  @override
  List<Object> get props => [];
}

class DetailProductStarted extends DetailProductEvent {
  final int idProduct;
  const DetailProductStarted({
    required this.idProduct,
  });
}
