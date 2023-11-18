import 'package:flutter/material.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/detail_category_bloc/detail_category_bloc.dart';
import 'package:provider/provider.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category category;

  const DeleteCategoryDialog({
    super.key,
    required this.category,
  });

  void deleteDiary(BuildContext context) {
    Navigator.pop(context, true);
    context
        .read<DetailCategoryBloc>()
        .add(DeleteCategorySubmitted(id: category.id!));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      backgroundColor: Colors.white,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete Category',
              style: AppStyles.semibold.copyWith(
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hành động này không thể quay lại',
              style: AppStyles.medium.copyWith(
                color: const Color(0xFFFF5252),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => deleteDiary(context),
                  child: Text(
                    'Delete',
                    style: AppStyles.regular.copyWith(
                      fontSize: 16,
                      color: const Color(0xFFFF5252),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2699E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppStyles.regular.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
