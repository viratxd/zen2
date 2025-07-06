import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateSessionButtonWidget extends StatelessWidget {
  final bool canCreate;
  final bool isCreating;
  final VoidCallback onPressed;

  const CreateSessionButtonWidget({
    Key? key,
    required this.canCreate,
    required this.isCreating,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: canCreate ? onPressed : null,
        style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.12);
            }
            return AppTheme.lightTheme.colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.38);
            }
            return AppTheme.lightTheme.colorScheme.onPrimary;
          }),
        ),
        child: isCreating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Creating Session...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: canCreate
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.38),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Create Session',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
