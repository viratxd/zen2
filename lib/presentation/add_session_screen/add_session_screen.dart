import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selector_widget.dart';
import './widgets/create_session_button_widget.dart';
import './widgets/icon_selector_widget.dart';
import './widgets/session_label_widget.dart';
import './widgets/url_input_widget.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({Key? key}) : super(key: key);

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _labelController = TextEditingController();
  final _urlFocusNode = FocusNode();
  final _labelFocusNode = FocusNode();

  String? _selectedCategory;
  String? _selectedIcon;
  bool _isUrlValid = false;
  bool _isLabelValid = false;
  bool _isCreatingSession = false;

  // Mock categories data
  final List<String> _categories = [
    'Work',
    'Personal',
    'Social Media',
    'Shopping',
    'Entertainment',
    'Education',
    'Finance',
    'Health',
  ];

  // Mock existing session labels to prevent duplicates
  final List<String> _existingLabels = [
    'Gmail Work',
    'Facebook Personal',
    'LinkedIn Profile',
    'Amazon Shopping',
    'Netflix Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_validateUrl);
    _labelController.addListener(_validateLabel);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _labelController.dispose();
    _urlFocusNode.dispose();
    _labelFocusNode.dispose();
    super.dispose();
  }

  void _validateUrl() {
    final url = _urlController.text.trim();
    final isValid = url.isNotEmpty &&
        (url.startsWith('http://') ||
            url.startsWith('https://') ||
            url.contains('.'));
    setState(() {
      _isUrlValid = isValid;
    });
  }

  void _validateLabel() {
    final label = _labelController.text.trim();
    final isValid = label.isNotEmpty &&
        label.length >= 3 &&
        !_existingLabels.contains(label);
    setState(() {
      _isLabelValid = isValid;
    });
  }

  bool get _canCreateSession {
    return _isUrlValid && _isLabelValid && !_isCreatingSession;
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onIconSelected(String? icon) {
    setState(() {
      _selectedIcon = icon;
    });
  }

  Future<void> _createSession() async {
    if (!_canCreateSession) return;

    setState(() {
      _isCreatingSession = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate session creation delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate UUID-based session identifier (mock)
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Mock session creation success
      if (mounted) {
        // Show success feedback
        HapticFeedback.mediumImpact();

        // Navigate back to dashboard
        Navigator.pop(context, {
          'sessionId': sessionId,
          'url': _urlController.text.trim(),
          'label': _labelController.text.trim(),
          'category': _selectedCategory ?? 'Uncategorized',
          'icon': _selectedIcon ?? 'web',
        });
      }
    } catch (e) {
      if (mounted) {
        // Show error feedback
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create session. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingSession = false;
        });
      }
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Add New Session',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: _dismissKeyboard,
            child: Text(
              'Done',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: _dismissKeyboard,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // URL Input
                        UrlInputWidget(
                          controller: _urlController,
                          focusNode: _urlFocusNode,
                          isValid: _isUrlValid,
                          onFieldSubmitted: (_) {
                            _labelFocusNode.requestFocus();
                          },
                        ),

                        SizedBox(height: 4.h),

                        // Session Label Input
                        SessionLabelWidget(
                          controller: _labelController,
                          focusNode: _labelFocusNode,
                          isValid: _isLabelValid,
                          existingLabels: _existingLabels,
                          onFieldSubmitted: (_) {
                            _dismissKeyboard();
                          },
                        ),

                        SizedBox(height: 4.h),

                        // Category Selector
                        CategorySelectorWidget(
                          categories: _categories,
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _onCategorySelected,
                        ),

                        SizedBox(height: 4.h),

                        // Icon Selector
                        IconSelectorWidget(
                          selectedIcon: _selectedIcon,
                          onIconSelected: _onIconSelected,
                          url: _urlController.text.trim(),
                        ),

                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Create Session Button
                      CreateSessionButtonWidget(
                        canCreate: _canCreateSession,
                        isCreating: _isCreatingSession,
                        onPressed: _createSession,
                      ),

                      SizedBox(height: 2.h),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: OutlinedButton(
                          onPressed: _isCreatingSession
                              ? null
                              : () => Navigator.pop(context),
                          style: AppTheme.lightTheme.outlinedButtonTheme.style
                              ?.copyWith(
                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _isCreatingSession
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.4)
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
