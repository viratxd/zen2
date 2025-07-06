import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IconSelectorWidget extends StatelessWidget {
  final String? selectedIcon;
  final Function(String?) onIconSelected;
  final String url;

  const IconSelectorWidget({
    Key? key,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.url,
  }) : super(key: key);

  void _showIconPickerModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _IconPickerModal(
            selectedIcon: selectedIcon,
            onIconSelected: onIconSelected,
            url: url));
  }

  String _getDisplayIcon() {
    if (selectedIcon != null) return selectedIcon!;
    if (url.isNotEmpty) return 'language';
    return 'web';
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Session Icon',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w500)),
      SizedBox(height: 1.h),
      InkWell(
          onTap: () => _showIconPickerModal(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1)),
              child: Row(children: [
                Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                        child: CustomIconWidget(
                            iconName: _getDisplayIcon(),
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24))),
                SizedBox(width: 3.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          selectedIcon != null
                              ? 'Custom Icon Selected'
                              : 'Auto-detect Favicon',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 0.5.h),
                      Text(
                          selectedIcon != null
                              ? 'Tap to change icon'
                              : 'Will fetch website favicon automatically',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                    ])),
                CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20),
              ]))),
      SizedBox(height: 1.h),
      Text(
          'Choose an icon to represent your session or let us auto-fetch the website favicon',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
    ]);
  }
}

class _IconPickerModal extends StatefulWidget {
  final String? selectedIcon;
  final Function(String?) onIconSelected;
  final String url;

  const _IconPickerModal({
    Key? key,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.url,
  }) : super(key: key);

  @override
  State<_IconPickerModal> createState() => _IconPickerModalState();
}

class _IconPickerModalState extends State<_IconPickerModal> {
  final List<String> _defaultIcons = [
    'web',
    'language',
    'public',
    'computer',
    'smartphone',
    'tablet',
    'work',
    'business',
    'email',
    'chat',
    'shopping_cart',
    'store',
    'movie',
    'music_note',
    'games',
    'sports_esports',
    'school',
    'book',
    'account_balance',
    'credit_card',
    'local_hospital',
    'fitness_center',
    'restaurant',
    'local_cafe',
    'directions_car',
    'flight',
    'hotel',
    'map',
  ];

  void _selectIcon(String? icon) {
    widget.onIconSelected(icon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70.h,
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16))),
        child: Column(children: [
          // Handle bar
          Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2))),

          // Header
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(children: [
                Text('Choose Icon',
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24)),
              ])),

          // Options
          Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  children: [
                // Auto-fetch favicon option
                _buildOptionTile(
                    icon: 'language',
                    title: 'Auto-fetch Favicon',
                    subtitle: 'Automatically detect and use website favicon',
                    isSelected: widget.selectedIcon == null,
                    onTap: () => _selectIcon(null)),

                SizedBox(height: 2.h),

                // Default icons section
                Text('Default Icons',
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),

                SizedBox(height: 1.h),

                // Icons grid
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                        childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      final iconName = _defaultIcons[index];
                      final isSelected = widget.selectedIcon == iconName;

                      return InkWell(
                          onTap: () => _selectIcon(iconName),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme.lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.3),
                                      width: isSelected ? 2 : 1)),
                              child: Center(
                                  child: CustomIconWidget(
                                      iconName: iconName,
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                      size: 24))));
                    }),

                SizedBox(height: 4.h),
              ])),
        ]));
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1)),
            child: Row(children: [
              Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: CustomIconWidget(
                          iconName: icon,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24))),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: AppTheme.lightTheme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 0.5.h),
                    Text(subtitle,
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant)),
                  ])),
              if (isSelected)
                CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
            ])));
  }
}
