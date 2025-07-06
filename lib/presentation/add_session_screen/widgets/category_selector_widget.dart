import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategorySelectorWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryBottomSheet(
        categories: categories,
        selectedCategory: selectedCategory,
        onCategorySelected: onCategorySelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: () => _showCategoryBottomSheet(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'category',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    selectedCategory ?? 'Select a category (optional)',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: selectedCategory != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Organize your sessions by category for better management',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryBottomSheet extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const _CategoryBottomSheet({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<_CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<_CategoryBottomSheet> {
  final TextEditingController _newCategoryController = TextEditingController();
  bool _isCreatingNew = false;

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  void _selectCategory(String? category) {
    widget.onCategorySelected(category);
    Navigator.pop(context);
  }

  void _createNewCategory() {
    final newCategory = _newCategoryController.text.trim();
    if (newCategory.isNotEmpty && !widget.categories.contains(newCategory)) {
      _selectCategory(newCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Select Category',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Categories list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                // None option
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  title: Text(
                    'None',
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  trailing: widget.selectedCategory == null
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () => _selectCategory(null),
                ),

                // Existing categories
                ...widget.categories.map((category) => ListTile(
                      leading: CustomIconWidget(
                        iconName: _getCategoryIcon(category),
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      title: Text(
                        category,
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      trailing: widget.selectedCategory == category
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            )
                          : null,
                      onTap: () => _selectCategory(category),
                    )),

                // Create new category
                if (!_isCreatingNew)
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Create New Category',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isCreatingNew = true;
                      });
                    },
                  ),

                // New category input
                if (_isCreatingNew)
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newCategoryController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Enter category name',
                              isDense: true,
                            ),
                            onSubmitted: (_) => _createNewCategory(),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: _createNewCategory,
                          icon: CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isCreatingNew = false;
                              _newCategoryController.clear();
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return 'work';
      case 'personal':
        return 'person';
      case 'social media':
        return 'share';
      case 'shopping':
        return 'shopping_cart';
      case 'entertainment':
        return 'movie';
      case 'education':
        return 'school';
      case 'finance':
        return 'account_balance';
      case 'health':
        return 'local_hospital';
      default:
        return 'folder';
    }
  }
}
