// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'review_order_bloc.dart';

abstract class ReviewOrderEvent extends Equatable {
  const ReviewOrderEvent();

  @override
  List<Object> get props => [];
}

class ReviewStarted extends ReviewOrderEvent {
  final int idProduct;
  ReviewStarted({
    required this.idProduct,
  });
}

class ReviewSubmitted extends ReviewOrderEvent {
  final File image;
  final String review;
  final double rating;
  final String idProduct;

  const ReviewSubmitted({
    required this.image,
    required this.review,
    required this.rating,
    required this.idProduct,
  });

  @override
  List<Object> get props => [image, review, rating, idProduct];
}
