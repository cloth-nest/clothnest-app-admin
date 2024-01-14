part of 'product_attribute_bloc.dart';

abstract class ProductAttributeEvent extends Equatable {
  const ProductAttributeEvent();

  @override
  List<Object> get props => [];
}

class ProductAttributeStarted extends ProductAttributeEvent {
  final BuildContext context;

  const ProductAttributeStarted(this.context);
}

class ProductAttributeAdded extends ProductAttributeEvent {
  final BuildContext context;
  final String attribute;

  const ProductAttributeAdded(
    this.context,
    this.attribute,
  );
}

class ProductAttributeDeleted extends ProductAttributeEvent {
  final BuildContext context;
  final int idProductAttribute;

  const ProductAttributeDeleted(
    this.context,
    this.idProductAttribute,
  );
}
