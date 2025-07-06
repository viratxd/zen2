import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _loadSessionMetadata(),
        _initializeWebViewManager(),
        _prepareCachedFavicons(),
        _validateSessionData(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToDashboard();
      }
    } catch (error) {
      if (mounted) {
        _handleInitializationError(error);
      }
    }
  }

  Future<void> _loadSessionMetadata() async {
    // Simulate loading session metadata from Hive/Isar database
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeWebViewManager() async {
    // Simulate initializing webview_cookie_manager_plus for session isolation
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _prepareCachedFavicons() async {
    // Simulate preparing cached favicons
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _validateSessionData() async {
    // Simulate validating stored session data integrity
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToDashboard() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/session-dashboard');
  }

  void _handleInitializationError(dynamic error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Initialization Error',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Failed to initialize the application. Please try again.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.surface,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              _buildLogo(),
              const SizedBox(height: 32),
              _buildAppName(),
              const SizedBox(height: 16),
              _buildTagline(),
              const Spacer(flex: 2),
              _buildLoadingIndicator(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'web',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 64,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Zentab',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Multi-Session WebView Manager',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _isInitialized ? 'Ready to launch' : 'Initializing sessions...',
            key: ValueKey(_isInitialized),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
