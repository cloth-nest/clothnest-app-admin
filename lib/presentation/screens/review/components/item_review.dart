import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          comment.avatar != null
              ? Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(comment.avatar!),
                    ),
                  ),
                )
              : Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(AppAssets.icUser),
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
                  style: AppStyles.semibold.copyWith(fontSize: 17.0),
                ),
                Text(
                  comment.content,
                  style: AppStyles.regular.copyWith(fontSize: 15.0),
                ),
                const SizedBox(height: 5.0),
                if (comment.images.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...comment.images.map(
                        (image) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            image,
                            width: 70,
                            height: 70,
                            cacheWidth: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 70,
                                height: 70,
                                color: AppColors.boxBackgroundColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(comment.createdAt)),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 13),
                ),
                RatingBar.builder(
                  initialRating: comment.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 17,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0xFFFFB930),
                  ),
                  onRatingUpdate: (value) {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
