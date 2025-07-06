import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryFilterWidget extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(List<String>) onCategoryFilterChanged;

  const CategoryFilterWidget({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoryFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      itemCount: selectedCategories.length + 1,
      separatorBuilder: (context, index) => SizedBox(width: 2.w),
      itemBuilder: (context, index) {
        if (index == selectedCategories.length) {
          return _buildClearAllChip(context);
        }

        final category = selectedCategories[index];
        final sessionCount = _getSessionCountForCategory(category);

        return _buildCategoryChip(
          context,
          category: category,
          sessionCount: sessionCount,
          onRemove: () {
            final updated = List<String>.from(selectedCategories);
            updated.remove(category);
            onCategoryFilterChanged(updated);
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String category,
    required int sessionCount,
    required VoidCallback onRemove,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (sessionCount > 0) ...[
                SizedBox(width: 1.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    sessionCount.toString(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'close',
                size: 4.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearAllChip(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onCategoryFilterChanged([]);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Clear All',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onError,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'clear',
                size: 4.w,
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSessionCountForCategory(String category) {
    // Mock implementation - in real app, this would be calculated
    // based on actual filtered sessions
    return 3;
  }
}
