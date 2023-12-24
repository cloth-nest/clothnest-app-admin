import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assign_attributes_event.dart';
part 'assign_attributes_state.dart';

class AssignAttributesBloc
    extends Bloc<AssignAttributesEvent, AssignAttributesState> {
  AssignAttributesBloc() : super(AssignAttributesInitial()) {
    on<AssignAttributesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
