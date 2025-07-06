import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateSession;
  final bool hasSearchQuery;

  const EmptyStateWidget({
    Key? key,
    required this.onCreateSession,
    this.hasSearchQuery = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: hasSearchQuery ? 'search_off' : 'tab',
                  size: 15.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              hasSearchQuery ? 'No Results Found' : 'No Sessions Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              hasSearchQuery
                  ? 'Try adjusting your search terms or filters to find what you\'re looking for.'
                  : 'Create your first session to start browsing with unlimited tabs and enhanced privacy.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            // Action Button
            if (!hasSearchQuery)
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: onCreateSession,
                  style: AppTheme.lightTheme.elevatedButtonTheme.style,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        size: 5.w,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Create Your First Session',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
