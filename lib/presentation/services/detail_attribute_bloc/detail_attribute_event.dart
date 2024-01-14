part of 'detail_attribute_bloc.dart';

abstract class DetailAttributeEvent extends Equatable {
  const DetailAttributeEvent();

  @override
  List<Object> get props => [];
}

class DetailAttributeStarted extends DetailAttributeEvent {
  final BuildContext context;
  final int id;

  const DetailAttributeStarted(this.context, this.id);
}

class DetailAttributeAdded extends DetailAttributeEvent {
  final BuildContext context;
  final String attribute;
  final int id;

  const DetailAttributeAdded(
    this.context,
    this.attribute,
    this.id,
  );
}

class DetailAttributeUpdated extends DetailAttributeEvent {
  final BuildContext context;
  final String attribute;
  final int id;
  final int idProductAttribute;

  const DetailAttributeUpdated(
    this.context,
    this.attribute,
    this.id,
    this.idProductAttribute,
  );
}

class DetailAttributeDeleted extends DetailAttributeEvent {
  final BuildContext context;
  final int id;
  final int idProductAttribute;

  const DetailAttributeDeleted(
    this.context,
    this.id,
    this.idProductAttribute,
  );
}

class ProductAttributeUpdated extends DetailAttributeEvent {
  final BuildContext context;
  final String attribute;
  final int id;

  const ProductAttributeUpdated(
    this.context,
    this.attribute,
    this.id,
  );
}
