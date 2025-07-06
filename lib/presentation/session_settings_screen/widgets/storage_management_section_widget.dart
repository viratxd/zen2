import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StorageManagementSectionWidget extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final Function(String) onStorageCleared;

  const StorageManagementSectionWidget({
    Key? key,
    required this.sessionData,
    required this.onStorageCleared,
  }) : super(key: key);

  @override
  State<StorageManagementSectionWidget> createState() =>
      _StorageManagementSectionWidgetState();
}

class _StorageManagementSectionWidgetState
    extends State<StorageManagementSectionWidget> {
  bool _isClearing = false;

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
              'Storage Management',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildStorageInfo(),
            SizedBox(height: 2.h),
            _buildStorageActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'storage',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Storage Usage',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.sessionData['storageSize'] ?? '0 MB',
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Last updated: ${_formatLastModified()}',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageActions() {
    return Column(
      children: [
        _buildStorageAction(
          icon: 'cached',
          title: 'Clear Cache',
          subtitle: 'Remove temporary files and images',
          onTap: () => _showClearConfirmation('Cache'),
          isDestructive: false,
        ),
        SizedBox(height: 1.h),
        _buildStorageAction(
          icon: 'cookie',
          title: 'Clear Cookies',
          subtitle: 'Remove stored login sessions',
          onTap: () => _showClearConfirmation('Cookies'),
          isDestructive: false,
        ),
        SizedBox(height: 1.h),
        _buildStorageAction(
          icon: 'delete_sweep',
          title: 'Clear All Data',
          subtitle: 'Remove all session data and settings',
          onTap: () => _showClearConfirmation('All Data'),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildStorageAction({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDestructive,
  }) {
    return InkWell(
      onTap: _isClearing ? null : onTap,
      borderRadius: BorderRadius.circular(2.w),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Center(
                child: _isClearing
                    ? SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDestructive
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: icon,
                        color: isDestructive
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(String storageType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Clear $storageType',
          style: TextStyle(
            color: storageType == 'All Data'
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          storageType == 'All Data'
              ? 'This will permanently remove all session data including cookies, cache, and stored information. You will need to log in again.'
              : 'Are you sure you want to clear $storageType? This action cannot be undone.',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearStorage(storageType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: storageType == 'All Data'
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: storageType == 'All Data'
                  ? AppTheme.lightTheme.colorScheme.onError
                  : AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearStorage(String storageType) async {
    setState(() {
      _isClearing = true;
    });

    try {
      // Use the new cookie manager for clearing cookies
      if (storageType == 'Cookies') {
        await SessionCookieManager.clearSessionCookies(
            widget.sessionData['id'] ?? 'default');
      } else if (storageType == 'All Data') {
        await SessionCookieManager.clearSessionCookies(
            widget.sessionData['id'] ?? 'default');
        // Clear domain-specific cookies
        if (widget.sessionData['domain'] != null) {
          await SessionCookieManager.clearDomainCookies(
              widget.sessionData['domain']);
        }
      }

      // Simulate clearing operation
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isClearing = false;
        // Update storage size after clearing
        if (storageType == 'All Data') {
          widget.sessionData['storageSize'] = '0 MB';
        } else if (storageType == 'Cache') {
          widget.sessionData['storageSize'] = '8.2 MB';
        } else if (storageType == 'Cookies') {
          widget.sessionData['storageSize'] = '11.1 MB';
        }
        widget.sessionData['lastModified'] = DateTime.now();
      });

      widget.onStorageCleared(storageType);
    } catch (e) {
      setState(() {
        _isClearing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing $storageType: $e'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatLastModified() {
    final lastModified = widget.sessionData['lastModified'] as DateTime?;
    if (lastModified == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastModified);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
