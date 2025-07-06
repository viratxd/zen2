import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ViewToggleWidget extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onToggle;

  const ViewToggleWidget({
    Key? key,
    required this.isGridView,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 10.w,
          height: 10.w,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: CustomIconWidget(
                key: ValueKey(isGridView),
                iconName: isGridView ? 'view_list' : 'view_module',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
