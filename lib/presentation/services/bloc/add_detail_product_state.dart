// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_detail_product_bloc.dart';

abstract class AddDetailProductState extends Equatable {
  final List<Map<String, dynamic>> productAttributes;
  final List<Map<String, dynamic>> warehouses;

  const AddDetailProductState(
    this.productAttributes,
    this.warehouses,
  );

  @override
  List<Object> get props => [];
}

class AddDetailProductInitial extends AddDetailProductState {
  final DetailProduct product;

  const AddDetailProductInitial(
    super.productAttributes,
    super.warehouses, {
    required this.product,
  });
}

class AddDetailProductLoading extends AddDetailProductState {
  const AddDetailProductLoading(
    super.productAttributes,
    super.warehouses,
  );
}

class AddDetailProductLoaded extends AddDetailProductState {
  const AddDetailProductLoaded(
    super.productAttributes,
    super.warehouses,
  );
}

class AddDetailProductFailure extends AddDetailProductState {
  const AddDetailProductFailure(
    super.productAttributes,
    super.warehouses,
  );
}

class AddDetailProductSuccess extends AddDetailProductState {
  const AddDetailProductSuccess(
    super.productAttributes,
    super.warehouses,
  );
}
