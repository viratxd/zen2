import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WebViewAppBarWidget extends StatelessWidget {
  final String sessionLabel;
  final String currentDomain;
  final VoidCallback onClose;
  final VoidCallback onShare;
  final VoidCallback onCopyUrl;
  final VoidCallback onBookmark;
  final VoidCallback onPageInfo;

  const WebViewAppBarWidget({
    super.key,
    required this.sessionLabel,
    required this.currentDomain,
    required this.onClose,
    required this.onShare,
    required this.onCopyUrl,
    required this.onBookmark,
    required this.onPageInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Close Button
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'close',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Session Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sessionLabel,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.2.h),
                Text(
                  currentDomain,
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 12,
                  ).copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // More Options Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  onShare();
                  break;
                case 'copy':
                  onCopyUrl();
                  break;
                case 'bookmark':
                  onBookmark();
                  break;
                case 'info':
                  onPageInfo();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'share',
                      size: 4.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    const Text('Share URL'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'content_copy',
                      size: 4.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    const Text('Copy URL'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'bookmark',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'bookmark_add',
                      size: 4.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    const Text('Bookmark'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      size: 4.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    const Text('Page Info'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'more_vert',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
