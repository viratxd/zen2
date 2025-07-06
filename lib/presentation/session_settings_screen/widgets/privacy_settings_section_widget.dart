import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final VoidCallback onChanged;

  const PrivacySettingsSectionWidget({
    Key? key,
    required this.sessionData,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PrivacySettingsSectionWidget> createState() =>
      _PrivacySettingsSectionWidgetState();
}

class _PrivacySettingsSectionWidgetState
    extends State<PrivacySettingsSectionWidget> {
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
              'Privacy Settings',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildPrivacyToggle(
              icon: 'code',
              title: 'JavaScript',
              subtitle: 'Enable JavaScript execution',
              value: widget.sessionData['isJavaScriptEnabled'] ?? true,
              onChanged: (value) {
                setState(() {
                  widget.sessionData['isJavaScriptEnabled'] = value;
                });
                widget.onChanged();
              },
            ),
            _buildDivider(),
            _buildPrivacyToggle(
              icon: 'cookie',
              title: 'Cookies',
              subtitle: 'Accept and store cookies',
              value: widget.sessionData['areCookiesAccepted'] ?? true,
              onChanged: (value) async {
                setState(() {
                  widget.sessionData['areCookiesAccepted'] = value;
                });

                // Apply cookie policy immediately
                await SessionCookieManager.setCookieAcceptPolicy(value);

                // If cookies are disabled, clear existing cookies
                if (!value) {
                  await SessionCookieManager.clearSessionCookies(
                      widget.sessionData['id'] ?? 'default');
                }

                widget.onChanged();
              },
            ),
            _buildDivider(),
            _buildPrivacyToggle(
              icon: 'location_on',
              title: 'Location Access',
              subtitle: 'Allow location sharing',
              value: widget.sessionData['hasLocationAccess'] ?? false,
              onChanged: (value) {
                setState(() {
                  widget.sessionData['hasLocationAccess'] = value;
                });
                widget.onChanged();
              },
            ),
            _buildDivider(),
            _buildPrivacyToggle(
              icon: 'camera_alt',
              title: 'Camera Access',
              subtitle: 'Allow camera usage',
              value: widget.sessionData['hasCameraAccess'] ?? false,
              onChanged: (value) {
                setState(() {
                  widget.sessionData['hasCameraAccess'] = value;
                });
                widget.onChanged();
              },
            ),
            _buildDivider(),
            _buildPrivacyToggle(
              icon: 'mic',
              title: 'Microphone Access',
              subtitle: 'Allow microphone usage',
              value: widget.sessionData['hasMicrophoneAccess'] ?? false,
              onChanged: (value) {
                setState(() {
                  widget.sessionData['hasMicrophoneAccess'] = value;
                });
                widget.onChanged();
              },
            ),
            _buildDivider(),
            _buildPrivacyToggle(
              icon: 'block',
              title: 'Block Popups',
              subtitle: 'Prevent popup windows',
              value: widget.sessionData['isPopupBlocked'] ?? true,
              onChanged: (value) {
                setState(() {
                  widget.sessionData['isPopupBlocked'] = value;
                });
                widget.onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: value
                    ? AppTheme.lightTheme.colorScheme.primary
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
                    color: AppTheme.lightTheme.colorScheme.onSurface,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Divider(
        color: AppTheme.lightTheme.dividerColor,
        thickness: 0.5,
        indent: 13.w,
      ),
    );
  }
}
