import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionDetailsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final VoidCallback onChanged;

  const SessionDetailsSectionWidget({
    Key? key,
    required this.sessionData,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SessionDetailsSectionWidget> createState() =>
      _SessionDetailsSectionWidgetState();
}

class _SessionDetailsSectionWidgetState
    extends State<SessionDetailsSectionWidget> {
  late TextEditingController _labelController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Email',
    'Social Media',
    'Work',
    'Personal',
    'Shopping',
    'Entertainment',
    'News',
    'Education',
    'Finance',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.sessionData['label']);
    _selectedCategory = widget.sessionData['category'] ?? 'Other';
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

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
              'Session Details',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSessionIconPreview(),
            SizedBox(height: 2.h),
            _buildLabelField(),
            SizedBox(height: 2.h),
            _buildCategoryDropdown(),
            SizedBox(height: 2.h),
            _buildDomainInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionIconPreview() {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.w),
            child: widget.sessionData['iconUrl'] != null
                ? CustomImageWidget(
                    imageUrl: widget.sessionData['iconUrl'],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'language',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Session Icon',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Favicon automatically detected',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _showIconSelectionDialog,
          child: Text(
            'Change',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Label',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _labelController,
          decoration: InputDecoration(
            hintText: 'Enter session label',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'label',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
          ),
          onChanged: (value) {
            widget.sessionData['label'] = value;
            widget.onChanged();
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
              widget.sessionData['category'] = value;
              widget.onChanged();
            }
          },
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
          ),
          dropdownColor: AppTheme.lightTheme.cardColor,
        ),
      ],
    );
  }

  Widget _buildDomainInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'public',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Domain',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  widget.sessionData['domain'] ?? 'Unknown',
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Change Session Icon',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Use Favicon',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Text(
                'Automatically detect website icon',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onChanged();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Choose Custom Icon',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Text(
                'Select from gallery or icons',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement custom icon selection
                widget.onChanged();
              },
            ),
          ],
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
        ],
      ),
    );
  }
}
