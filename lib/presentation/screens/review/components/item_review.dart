import 'package:flutter/material.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:intl/intl.dart';

class ItemReview extends StatelessWidget {
  final Comment comment;

  const ItemReview({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(comment.avatar!),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comment.firstName} ${comment.lastName}',
                style: AppStyles.semibold.copyWith(fontSize: 16.0),
              ),
              Text(
                comment.content,
                style: AppStyles.regular.copyWith(fontSize: 14.0),
              ),
              const SizedBox(height: 5.0),
              if (comment.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    comment.image!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            DateFormat('dd/MM/yyyy').format(DateTime.parse(comment.createdAt!)),
            style: AppStyles.regular.copyWith(fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
