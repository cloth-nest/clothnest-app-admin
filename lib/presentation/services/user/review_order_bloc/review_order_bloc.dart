import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/data/repository/comment_repository.dart';
import 'package:grocery/data/services/cloudinary_service.dart';

part 'review_order_event.dart';
part 'review_order_state.dart';

class ReviewOrderBloc extends Bloc<ReviewOrderEvent, ReviewOrderState> {
  final CommentRepository _commentRepository;

  ReviewOrderBloc(this._commentRepository) : super(ReviewOrderInitial()) {
    on<ReviewSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onSubmitted(
      ReviewSubmitted event, Emitter<ReviewOrderState> emit) async {
    emit(ReviewOrderLoading());

    try {
      String? urlImage =
          await CloudinaryService().uploadImage(event.image.path, 'comments');
      Comment comment = Comment(
        content: event.review,
        productId: event.idProduct,
        image: urlImage!,
        rating: event.rating,
      );
      await _commentRepository.createComment(comment);
      emit(ReviewOrderSuccess());
    } catch (e) {
      emit(ReviewOrderFailure(errorMessage: e.toString()));
    }
  }
}
