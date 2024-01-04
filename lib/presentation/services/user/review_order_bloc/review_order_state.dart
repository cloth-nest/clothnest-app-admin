part of 'review_order_bloc.dart';

abstract class ReviewOrderState extends Equatable {
  const ReviewOrderState();

  @override
  List<Object> get props => [];
}

class ReviewOrderInitial extends ReviewOrderState {
  final List<Comment> comments;

  const ReviewOrderInitial({required this.comments});
}

class ReviewOrderLoading extends ReviewOrderState {}

class ReviewOrderFailure extends ReviewOrderState {
  final String errorMessage;

  const ReviewOrderFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ReviewOrderSuccess extends ReviewOrderState {}
