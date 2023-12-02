part of 'product_type_bloc.dart';

abstract class ProductTypeEvent extends Equatable {
  const ProductTypeEvent();

  @override
  List<Object> get props => [];
}

class ProductTypeStarted extends ProductTypeEvent {
  final BuildContext context;

  const ProductTypeStarted(this.context);
}

class ProductTypeAdded extends ProductTypeEvent {
  final BuildContext context;
  final String attribute;
  final int id;

  const ProductTypeAdded(
    this.context,
    this.attribute,
    this.id,
  );
}

class ProductAttributeUpdated extends ProductTypeEvent {
  final BuildContext context;
  final String attribute;
  final int id;

  const ProductAttributeUpdated(
    this.context,
    this.attribute,
    this.id,
  );
}
