import 'package:flutter/material.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/review/components/item_review.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class ReviewScreen extends StatelessWidget {
  final List<Comment> comments;

  const ReviewScreen({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Review',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 20,
          right: 20,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            Comment comment = comments[index];
            return ItemReview(comment: comment);
          },
        ),
      ),
    );
  }
}
