import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/data/repository/comment_repository.dart';

part 'review_order_event.dart';
part 'review_order_state.dart';

class ReviewOrderBloc extends Bloc<ReviewOrderEvent, ReviewOrderState> {
  final CommentRepository _commentRepository;

  ReviewOrderBloc(this._commentRepository) : super(ReviewOrderLoading()) {
    on<ReviewSubmitted>(_onSubmitted);
    on<ReviewStarted>(_onStarted);
  }

  FutureOr<void> _onSubmitted(
      ReviewSubmitted event, Emitter<ReviewOrderState> emit) async {
    emit(ReviewOrderLoading());

    try {
      emit(ReviewOrderSuccess());
    } catch (e) {
      emit(ReviewOrderFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStarted(
      ReviewStarted event, Emitter<ReviewOrderState> emit) async {
    emit(ReviewOrderLoading());

    try {
      List<Comment> comments =
          await _commentRepository.getComments(idProduct: event.idProduct);

      emit(ReviewOrderInitial(comments: comments));
    } catch (e) {
      emit(ReviewOrderFailure(errorMessage: e.toString()));
    }
  }
}
