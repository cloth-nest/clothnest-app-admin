// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_product_type_bloc.dart';

abstract class DetailProductTypeEvent extends Equatable {
  const DetailProductTypeEvent();

  @override
  List<Object> get props => [];
}

class DetailProductTypeInit extends DetailProductTypeEvent {
  final int productTypeId;
  const DetailProductTypeInit({
    required this.productTypeId,
  });
}

class ProductAttributesAdded extends DetailProductTypeEvent {
  final int productTypeId;
  final List<Attribute> attributes;

  const ProductAttributesAdded({
    required this.productTypeId,
    required this.attributes,
  });
}

class VariantAttributesAdded extends DetailProductTypeEvent {
  final int productTypeId;
  final List<Attribute> attributes;

  const VariantAttributesAdded({
    required this.productTypeId,
    required this.attributes,
  });
}
