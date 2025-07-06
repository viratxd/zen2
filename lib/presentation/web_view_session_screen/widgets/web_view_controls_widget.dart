import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WebViewControlsWidget extends StatelessWidget {
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;
  final VoidCallback onReload;
  final VoidCallback onClose;

  const WebViewControlsWidget({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.onGoBack,
    required this.onGoForward,
    required this.onReload,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Back Button
            _buildControlButton(
              iconName: 'arrow_back',
              onTap: canGoBack ? onGoBack : null,
              isEnabled: canGoBack,
            ),

            // Forward Button
            _buildControlButton(
              iconName: 'arrow_forward',
              onTap: canGoForward ? onGoForward : null,
              isEnabled: canGoForward,
            ),

            // Reload Button
            _buildControlButton(
              iconName: 'refresh',
              onTap: onReload,
              isEnabled: true,
            ),

            // Close Button
            _buildControlButton(
              iconName: 'close',
              onTap: onClose,
              isEnabled: true,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String iconName,
    required VoidCallback? onTap,
    required bool isEnabled,
    bool isDestructive = false,
  }) {
    final Color iconColor = !isEnabled
        ? AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3)
        : isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            size: 6.w,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
