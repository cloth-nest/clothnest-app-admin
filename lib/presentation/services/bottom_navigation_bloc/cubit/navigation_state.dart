part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final NavBarItem navBarItem;
  final int index;

  const NavigationState({required this.navBarItem, required this.index});

  @override
  List<Object> get props => [navBarItem, index];
}
