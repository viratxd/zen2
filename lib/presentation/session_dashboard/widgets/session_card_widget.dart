import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionCardWidget extends StatelessWidget {
  final Map<String, dynamic> session;
  final bool isGridView;
  final VoidCallback onLaunch;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const SessionCardWidget({
    Key? key,
    required this.session,
    required this.isGridView,
    required this.onLaunch,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('session_${session['id']}'),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(context, isLeft: false),
      secondaryBackground: _buildSwipeBackground(context, isLeft: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe left - Delete
          HapticFeedback.lightImpact();
          onDelete();
          return false;
        } else if (direction == DismissDirection.startToEnd) {
          // Swipe right - Quick actions
          HapticFeedback.lightImpact();
          _showQuickActions(context);
          return false;
        }
        return false;
      },
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showContextMenu(context);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onLaunch();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isGridView
                  ? _buildGridCard(context)
                  : _buildListCard(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildFavicon(),
            Spacer(),
            if (session['isActive'])
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session['label'],
                style: AppTheme.lightTheme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                session['domain'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              _buildCategoryChip(context),
              Spacer(),
              _buildActionButtons(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Row(
      children: [
        _buildFavicon(),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session['label'],
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (session['isActive'])
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                session['domain'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  _buildCategoryChip(context),
                  Spacer(),
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavicon() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: session['favicon'],
          width: 10.w,
          height: 10.w,
          fit: BoxFit.cover,
          errorWidget: Container(
            width: 10.w,
            height: 10.w,
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            child: CustomIconWidget(
              iconName: 'language',
              size: 5.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        session['category'],
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context,
          icon: 'launch',
          onTap: onLaunch,
        ),
        SizedBox(width: 1.w),
        _buildActionButton(
          context,
          icon: 'edit',
          onTap: onEdit,
        ),
        SizedBox(width: 1.w),
        _buildActionButton(
          context,
          icon: 'more_vert',
          onTap: () => _showContextMenu(context),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 8.w,
          height: 8.w,
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'edit',
            size: 6.w,
            color: Colors.white,
          ),
          SizedBox(width: 2.w),
          Text(
            isLeft ? 'Delete' : 'Edit',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              _buildBottomSheetAction(
                context,
                icon: 'edit',
                title: 'Edit Label',
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              _buildBottomSheetAction(
                context,
                icon: 'content_copy',
                title: 'Duplicate Session',
                onTap: () {
                  Navigator.pop(context);
                  onDuplicate();
                },
              ),
              _buildBottomSheetAction(
                context,
                icon: 'folder',
                title: 'Change Category',
                onTap: () {
                  Navigator.pop(context);
                  // Handle category change
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session['label'],
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              _buildBottomSheetAction(
                context,
                icon: 'launch',
                title: 'Launch Session',
                onTap: () {
                  Navigator.pop(context);
                  onLaunch();
                },
              ),
              _buildBottomSheetAction(
                context,
                icon: 'edit',
                title: 'Edit Session',
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              _buildBottomSheetAction(
                context,
                icon: 'content_copy',
                title: 'Duplicate Session',
                onTap: () {
                  Navigator.pop(context);
                  onDuplicate();
                },
              ),
              _buildBottomSheetAction(
                context,
                icon: 'delete',
                title: 'Delete Session',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetAction(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 6.w,
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: isDestructive
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
