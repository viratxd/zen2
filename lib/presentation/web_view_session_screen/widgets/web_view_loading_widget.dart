import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WebViewLoadingWidget extends StatelessWidget {
  final double progress;

  const WebViewLoadingWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.5.h,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor:
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
