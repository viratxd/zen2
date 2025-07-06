import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/session_card_widget.dart';
import './widgets/session_search_widget.dart';
import './widgets/view_toggle_widget.dart';

class SessionDashboard extends StatefulWidget {
  const SessionDashboard({Key? key}) : super(key: key);

  @override
  State<SessionDashboard> createState() => _SessionDashboardState();
}

class _SessionDashboardState extends State<SessionDashboard>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();

  bool _isGridView = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  List<Map<String, dynamic>> _sessions = [];
  List<Map<String, dynamic>> _filteredSessions = [];

  // Mock categories
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

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _filterSessions();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreSessions();
    }
  }

  Future<void> _loadSessions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final newSessions = _generateMockSessions();
      setState(() {
        _sessions = newSessions;
        _filterSessions();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load sessions. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreSessions() async {
    if (_isLoading || _sessions.length >= 50) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final moreSessions = _generateMockSessions(startIndex: _sessions.length);
      setState(() {
        _sessions.addAll(moreSessions);
        _filterSessions();
      });
    } catch (e) {
      // Handle error silently for pagination
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshSessions() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final refreshedSessions = _generateMockSessions();
      setState(() {
        _sessions = refreshedSessions;
        _filterSessions();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh sessions.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _filterSessions() {
    List<Map<String, dynamic>> filtered = List.from(_sessions);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((session) {
        final label = session['label'].toString().toLowerCase();
        final domain = session['domain'].toString().toLowerCase();
        final category = session['category'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();

        return label.contains(query) ||
            domain.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Filter by categories
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((session) {
        return _selectedCategories.contains(session['category']);
      }).toList();
    }

    setState(() {
      _filteredSessions = filtered;
    });
  }

  List<Map<String, dynamic>> _generateMockSessions({int startIndex = 0}) {
    final domains = [
      'google.com',
      'facebook.com',
      'twitter.com',
      'linkedin.com',
      'amazon.com',
      'netflix.com',
      'youtube.com',
      'github.com',
      'stackoverflow.com',
      'medium.com',
    ];

    final labels = [
      'Work Gmail',
      'Personal Facebook',
      'Twitter Updates',
      'LinkedIn Profile',
      'Amazon Shopping',
      'Netflix Movies',
      'YouTube Music',
      'GitHub Projects',
      'Stack Overflow',
      'Medium Articles',
    ];

    return List.generate(10, (index) {
      final realIndex = startIndex + index;
      final domainIndex = realIndex % domains.length;
      final labelIndex = realIndex % labels.length;
      final categoryIndex = realIndex % _categories.length;

      return {
        'id': 'session_${realIndex + 1}',
        'label': '${labels[labelIndex]} ${realIndex + 1}',
        'domain': domains[domainIndex],
        'category': _categories[categoryIndex],
        'favicon':
            'https://www.google.com/s2/favicons?domain=${domains[domainIndex]}&sz=32',
        'url': 'https://${domains[domainIndex]}',
        'isActive': realIndex % 3 == 0,
        'lastAccessed': DateTime.now().subtract(Duration(hours: realIndex)),
      };
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
    HapticFeedback.selectionClick();
  }

  void _onCategoryFilterChanged(List<String> categories) {
    setState(() {
      _selectedCategories = categories;
      _filterSessions();
    });
  }

  void _navigateToAddSession() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addSessionScreen,
    );

    if (result != null && result is Map<String, dynamic>) {
      // Add new session to list
      setState(() {
        _sessions.insert(0, {
          'id': result['sessionId'],
          'label': result['label'],
          'domain': Uri.parse(result['url']).host,
          'category': result['category'],
          'favicon':
              'https://www.google.com/s2/favicons?domain=${Uri.parse(result['url']).host}&sz=32',
          'url': result['url'],
          'isActive': false,
          'lastAccessed': DateTime.now(),
        });
        _filterSessions();
      });

      HapticFeedback.lightImpact();
    }
  }

  void _onSessionLaunch(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      AppRoutes.webViewSessionScreen,
      arguments: {
        'sessionId': session['id'],
        'url': session['url'],
        'label': session['label'],
      },
    );
  }

  void _onSessionEdit(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      AppRoutes.sessionSettingsScreen,
      arguments: {
        'sessionId': session['id'],
        'sessionData': session,
      },
    );
  }

  void _onSessionDelete(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Session'),
        content: Text('Are you sure you want to delete "${session['label']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _sessions.removeWhere((s) => s['id'] == session['id']);
                _filterSessions();
              });
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _onSessionDuplicate(Map<String, dynamic> session) {
    final newSession = Map<String, dynamic>.from(session);
    newSession['id'] = 'session_${DateTime.now().millisecondsSinceEpoch}';
    newSession['label'] = '${session['label']} Copy';
    newSession['isActive'] = false;
    newSession['lastAccessed'] = DateTime.now();

    setState(() {
      _sessions.insert(_sessions.indexOf(session) + 1, newSession);
      _filterSessions();
    });

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Session Dashboard',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        centerTitle: false,
        actions: [
          ViewToggleWidget(
            isGridView: _isGridView,
            onToggle: _toggleView,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: SessionSearchWidget(
                controller: _searchController,
                onFilterTap: () {
                  _showCategoryFilter();
                },
                hasActiveFilters: _selectedCategories.isNotEmpty,
              ),
            ),

            // Category Filter Chips
            if (_selectedCategories.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: CategoryFilterWidget(
                  categories: _categories,
                  selectedCategories: _selectedCategories,
                  onCategoryFilterChanged: _onCategoryFilterChanged,
                ),
              ),

            // Sessions List/Grid
            Expanded(
              child: _isLoading && _sessions.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredSessions.isEmpty
                      ? EmptyStateWidget(
                          onCreateSession: _navigateToAddSession,
                          hasSearchQuery: _searchQuery.isNotEmpty,
                        )
                      : RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _refreshSessions,
                          child: _buildSessionsList(),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSession,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildSessionsList() {
    return _isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredSessions.length + (_isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredSessions.length) {
          return _buildSkeletonCard();
        }

        final session = _filteredSessions[index];
        return SessionCardWidget(
          session: session,
          isGridView: true,
          onLaunch: () => _onSessionLaunch(session),
          onEdit: () => _onSessionEdit(session),
          onDelete: () => _onSessionDelete(session),
          onDuplicate: () => _onSessionDuplicate(session),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      itemCount: _filteredSessions.length + (_isLoading ? 3 : 0),
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        if (index >= _filteredSessions.length) {
          return _buildSkeletonCard();
        }

        final session = _filteredSessions[index];
        return SessionCardWidget(
          session: session,
          isGridView: false,
          onLaunch: () => _onSessionLaunch(session),
          onEdit: () => _onSessionEdit(session),
          onDelete: () => _onSessionDelete(session),
          onDuplicate: () => _onSessionDuplicate(session),
        );
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 20.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
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
                'Filter by Category',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: _categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                        _filterSessions();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
