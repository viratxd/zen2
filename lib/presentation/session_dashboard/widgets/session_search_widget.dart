import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const SessionSearchWidget({
    Key? key,
    required this.controller,
    required this.onFilterTap,
    this.hasActiveFilters = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search sessions, domains, or categories...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 5.w,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor:
                  AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textInputAction: TextInputAction.search,
          ),
        ),
        SizedBox(width: 3.w),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: hasActiveFilters
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    CustomIconWidget(
                      iconName: 'filter_list',
                      size: 6.w,
                      color: hasActiveFilters
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    if (hasActiveFilters)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
