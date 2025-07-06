import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final VoidCallback onChanged;

  const AdvancedOptionsSectionWidget({
    Key? key,
    required this.sessionData,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AdvancedOptionsSectionWidget> createState() =>
      _AdvancedOptionsSectionWidgetState();
}

class _AdvancedOptionsSectionWidgetState
    extends State<AdvancedOptionsSectionWidget> {
  late TextEditingController _defaultUrlController;
  late String _selectedUserAgent;
  late double _zoomLevel;

  final List<Map<String, String>> _userAgents = [
    {
      'name': 'Mobile (Default)',
      'value': 'mobile',
      'description': 'Standard mobile browser'
    },
    {
      'name': 'Desktop',
      'value': 'desktop',
      'description': 'Desktop browser experience'
    },
    {
      'name': 'Tablet',
      'value': 'tablet',
      'description': 'Tablet optimized view'
    },
  ];

  @override
  void initState() {
    super.initState();
    _defaultUrlController = TextEditingController(
      text: widget.sessionData['defaultPageUrl'] ?? '',
    );
    _selectedUserAgent = widget.sessionData['userAgent'] ?? 'mobile';
    _zoomLevel = (widget.sessionData['zoomLevel'] ?? 1.0).toDouble();
  }

  @override
  void dispose() {
    _defaultUrlController.dispose();
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
              'Advanced Options',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildUserAgentSelection(),
            SizedBox(height: 2.h),
            _buildZoomLevelSlider(),
            SizedBox(height: 2.h),
            _buildDefaultUrlField(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAgentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Agent',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            children: _userAgents.map((agent) {
              final isSelected = _selectedUserAgent == agent['value'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedUserAgent = agent['value']!;
                  });
                  widget.sessionData['userAgent'] = agent['value'];
                  widget.onChanged();
                },
                borderRadius: BorderRadius.circular(2.w),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 2.w,
                                  height: 2.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agent['name']!,
                              style: TextStyle(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              agent['description']!,
                              style: TextStyle(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildZoomLevelSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Zoom Level',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Text(
                '\${(_zoomLevel * 100).round()}%',
                style: AppTheme.dataTextStyle(
                  isLight: true,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline,
            thumbColor: AppTheme.lightTheme.colorScheme.primary,
            overlayColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            trackHeight: 1.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
          ),
          child: Slider(
            value: _zoomLevel,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: (value) {
              setState(() {
                _zoomLevel = value;
              });
              widget.sessionData['zoomLevel'] = value;
              widget.onChanged();
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '50%',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 11.sp,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 11.sp,
              ),
            ),
            Text(
              '200%',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Default Page URL',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _defaultUrlController,
          decoration: InputDecoration(
            hintText: 'Enter default page URL',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'link',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: _defaultUrlController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _defaultUrlController.clear();
                      widget.sessionData['defaultPageUrl'] = '';
                      widget.onChanged();
                    },
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  )
                : null,
          ),
          style: AppTheme.dataTextStyle(
            isLight: true,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.url,
          onChanged: (value) {
            widget.sessionData['defaultPageUrl'] = value;
            widget.onChanged();
            setState(() {}); // Refresh to show/hide clear button
          },
        ),
        SizedBox(height: 1.h),
        Text(
          'This URL will be loaded when the session starts',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
