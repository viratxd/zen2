import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_section_widget.dart';
import './widgets/delete_session_section_widget.dart';
import './widgets/privacy_settings_section_widget.dart';
import './widgets/session_details_section_widget.dart';
import './widgets/storage_management_section_widget.dart';

class SessionSettingsScreen extends StatefulWidget {
  const SessionSettingsScreen({Key? key}) : super(key: key);

  @override
  State<SessionSettingsScreen> createState() => _SessionSettingsScreenState();
}

class _SessionSettingsScreenState extends State<SessionSettingsScreen> {
  // Mock session data
  final Map<String, dynamic> sessionData = {
    "id": "session_001",
    "label": "Work Gmail",
    "category": "Email",
    "iconUrl": "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico",
    "url": "https://mail.google.com",
    "domain": "mail.google.com",
    "isJavaScriptEnabled": true,
    "areCookiesAccepted": true,
    "hasLocationAccess": false,
    "hasCameraAccess": false,
    "hasMicrophoneAccess": false,
    "isPopupBlocked": true,
    "userAgent": "mobile",
    "zoomLevel": 1.0,
    "defaultPageUrl": "https://mail.google.com",
    "storageSize": "12.5 MB",
    "lastModified": DateTime.now().subtract(Duration(hours: 2)),
  };

  bool _hasUnsavedChanges = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await _showExitConfirmationDialog();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SessionDetailsSectionWidget(
                        sessionData: sessionData,
                        onChanged: _onSettingsChanged,
                      ),
                      SizedBox(height: 3.h),
                      PrivacySettingsSectionWidget(
                        sessionData: sessionData,
                        onChanged: _onSettingsChanged,
                      ),
                      SizedBox(height: 3.h),
                      StorageManagementSectionWidget(
                        sessionData: sessionData,
                        onStorageCleared: _onStorageCleared,
                      ),
                      SizedBox(height: 3.h),
                      AdvancedOptionsSectionWidget(
                        sessionData: sessionData,
                        onChanged: _onSettingsChanged,
                      ),
                      SizedBox(height: 3.h),
                      DeleteSessionSectionWidget(
                        sessionData: sessionData,
                        onDeleteConfirmed: _onDeleteSession,
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () async {
          if (_hasUnsavedChanges) {
            final shouldExit = await _showExitConfirmationDialog();
            if (shouldExit) {
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        },
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text(
        'Session Settings',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        if (_hasUnsavedChanges)
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Saving settings...',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _onSettingsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _onStorageCleared(String storageType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\$storageType cleared successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
            title: Text(
              'Unsaved Changes',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'You have unsaved changes. Are you sure you want to exit without saving?',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _onDeleteSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Delete Session',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.error,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this session? This action cannot be undone and all session data will be permanently removed.',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show second confirmation
      final doubleConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
          title: Text(
            'Final Confirmation',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.error,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'This is your final warning. Deleting "${sessionData["label"]}" will permanently remove all associated data. Type "DELETE" to confirm.',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: Text(
                'DELETE',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (doubleConfirmed == true) {
        // Navigate back to dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/session-dashboard',
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Session "${sessionData["label"]}" deleted successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
