part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class ShopCategoriesFetched extends ShopEvent {
  const ShopCategoriesFetched();
}
