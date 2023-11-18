import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/presentation/enum/enum.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(
          const NavigationState(
            navBarItem: NavBarItem.shop,
            index: 0,
          ),
        );

  void getNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.shop:
        emit(const NavigationState(navBarItem: NavBarItem.shop, index: 0));
        break;
      case NavBarItem.cart:
        emit(const NavigationState(navBarItem: NavBarItem.cart, index: 1));
        break;
      case NavBarItem.order:
        emit(const NavigationState(navBarItem: NavBarItem.order, index: 2));
        break;
      case NavBarItem.profile:
        emit(const NavigationState(navBarItem: NavBarItem.profile, index: 3));
        break;
    }
  }
}
