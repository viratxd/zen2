import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionLabelWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isValid;
  final List<String> existingLabels;
  final Function(String)? onFieldSubmitted;

  const SessionLabelWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isValid,
    required this.existingLabels,
    this.onFieldSubmitted,
  }) : super(key: key);

  String? _getErrorMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return null;

    if (text.length < 3) {
      return 'Label must be at least 3 characters';
    }

    if (existingLabels.contains(text)) {
      return 'This label already exists';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Session Label',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              '*',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            controller.text.isNotEmpty
                ? CustomIconWidget(
                    iconName: isValid ? 'check_circle' : 'error',
                    color: isValid
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  )
                : const SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLength: 50,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: 'e.g., Gmail Work Account',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'label',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  )
                : null,
            errorText: _getErrorMessage(),
            errorMaxLines: 2,
            counterText: '${controller.text.length}/50',
            counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Session label is required';
            }
            return _getErrorMessage();
          },
        ),
        SizedBox(height: 1.h),
        Text(
          'Give your session a memorable name to easily identify it',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
