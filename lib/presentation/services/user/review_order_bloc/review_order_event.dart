part of 'review_order_bloc.dart';

abstract class ReviewOrderEvent extends Equatable {
  const ReviewOrderEvent();

  @override
  List<Object> get props => [];
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
