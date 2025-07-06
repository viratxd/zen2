import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrlInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isValid;
  final Function(String)? onFieldSubmitted;

  const UrlInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isValid,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Website URL',
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
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: 'https://example.com',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'language',
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
            errorText: controller.text.isNotEmpty && !isValid
                ? 'Please enter a valid URL'
                : null,
            errorMaxLines: 2,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'URL is required';
            }
            if (!isValid) {
              return 'Please enter a valid URL (e.g., https://example.com)';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        Text(
          'Enter the website URL you want to create a session for',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
