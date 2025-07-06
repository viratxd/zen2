import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeleteSessionSectionWidget extends StatelessWidget {
  final Map<String, dynamic> sessionData;
  final VoidCallback onDeleteConfirmed;

  const DeleteSessionSectionWidget({
    Key? key,
    required this.sessionData,
    required this.onDeleteConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      color: AppTheme.lightTheme.cardTheme.color,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildWarningInfo(context),
            SizedBox(height: 2.h),
            _buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Session',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Permanently remove this session and all associated data including cookies, cache, and stored information. This action cannot be undone.',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onDeleteConfirmed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          foregroundColor: AppTheme.lightTheme.colorScheme.onError,
          padding: EdgeInsets.symmetric(vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete_forever',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Delete Session',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
