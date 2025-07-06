import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/web_view_app_bar_widget.dart';
import './widgets/web_view_controls_widget.dart';
import './widgets/web_view_loading_widget.dart';

class WebViewSessionScreen extends StatefulWidget {
  const WebViewSessionScreen({super.key});

  @override
  State<WebViewSessionScreen> createState() => _WebViewSessionScreenState();
}

class _WebViewSessionScreenState extends State<WebViewSessionScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = '';
  String _pageTitle = '';
  double _loadingProgress = 0.0;
  bool _hasError = false;
  String _errorMessage = '';

  // Mock session data - in real app this would come from arguments
  final Map<String, dynamic> _sessionData = {
    "sessionId": "550e8400-e29b-41d4-a716-446655440000",
    "label": "Work Gmail",
    "url": "https://mail.google.com",
    "category": "Email",
    "favicon": "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico",
    "domain": "mail.google.com",
    "createdAt": DateTime.now().subtract(const Duration(days: 2)),
    "lastAccessed": DateTime.now().subtract(const Duration(hours: 1)),
    "areCookiesAccepted": true,
    "isJavaScriptEnabled": true,
  };

  late InAppWebViewSettings _webViewSettings;

  @override
  void initState() {
    super.initState();
    _initializeWebViewSettings();
  }

  void _initializeWebViewSettings() {
    _webViewSettings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true,
      javaScriptEnabled: _sessionData['isJavaScriptEnabled'] ?? true,
      thirdPartyCookiesEnabled: _sessionData['areCookiesAccepted'] ?? true,
      clearCache: false,
      clearSessionCache: false,
      cacheEnabled: true,
      supportZoom: true,
      builtInZoomControls: true,
      displayZoomControls: false,
      useWideViewPort: true,
      loadWithOverviewMode: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            WebViewAppBarWidget(
              sessionLabel: _sessionData['label'] as String,
              currentDomain: _getDomainFromUrl(_currentUrl),
              onClose: _closeSession,
              onShare: _shareUrl,
              onCopyUrl: _copyUrl,
              onBookmark: _bookmarkPage,
              onPageInfo: _showPageInfo,
            ),

            // Loading Progress Indicator
            if (_isLoading) WebViewLoadingWidget(progress: _loadingProgress),

            // Main WebView Content
            Expanded(
              child: _hasError ? _buildErrorView() : _buildWebView(),
            ),

            // Bottom Controls
            WebViewControlsWidget(
              canGoBack: _canGoBack,
              canGoForward: _canGoForward,
              onGoBack: _goBack,
              onGoForward: _goForward,
              onReload: _reload,
              onClose: _closeSession,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri(_sessionData['url'] as String)),
        initialSettings: _webViewSettings,
        onWebViewCreated: (controller) {
          _webViewController = controller;
          _setupSessionCookies();
        },
        onLoadStart: (controller, url) {
          setState(() {
            _currentUrl = url?.toString() ?? '';
            _isLoading = true;
            _hasError = false;
          });
          _updateNavigationState();
        },
        onLoadStop: (controller, url) async {
          setState(() {
            _currentUrl = url?.toString() ?? '';
            _isLoading = false;
          });
          _updateNavigationState();
          await _getPageTitle();
        },
        onProgressChanged: (controller, progress) {
          setState(() {
            _loadingProgress = progress / 100.0;
            _isLoading = progress < 100;
          });
        },
        onReceivedError: (controller, request, error) {
          setState(() {
            _hasError = true;
            _errorMessage = error.description;
            _isLoading = false;
          });
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }

  void _setupSessionCookies() async {
    if (_sessionData['areCookiesAccepted'] == false) {
      await SessionCookieManager.clearSessionCookies(_sessionData['sessionId']);
    }
    await SessionCookieManager.setCookieAcceptPolicy(
        _sessionData['areCookiesAccepted'] ?? true);
  }

  void _updateNavigationState() async {
    if (_webViewController != null) {
      final canGoBack = await _webViewController!.canGoBack();
      final canGoForward = await _webViewController!.canGoForward();
      setState(() {
        _canGoBack = canGoBack;
        _canGoForward = canGoForward;
      });
    }
  }

  Future<void> _getPageTitle() async {
    if (_webViewController != null) {
      final title = await _webViewController!.getTitle();
      setState(() {
        _pageTitle = title ?? '';
      });
    }
  }

  void _goBack() async {
    if (_canGoBack && _webViewController != null) {
      await _webViewController!.goBack();
    }
  }

  void _goForward() async {
    if (_canGoForward && _webViewController != null) {
      await _webViewController!.goForward();
    }
  }

  void _reload() async {
    if (_webViewController != null) {
      await _webViewController!.reload();
    }
  }

  void _closeSession() {
    Navigator.pop(context);
  }

  void _shareUrl() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $_currentUrl'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyUrl() {
    Clipboard.setData(ClipboardData(text: _currentUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkPage() {
    // Mock bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarked: $_pageTitle'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Page Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $_pageTitle'),
            SizedBox(height: 1.h),
            Text('URL: $_currentUrl'),
            SizedBox(height: 1.h),
            Text('Session: ${_sessionData['label']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _retryLoading() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _reload();
  }

  Widget _buildErrorView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            size: 15.w,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
          SizedBox(height: 2.h),
          Text(
            'Failed to load page',
            style: AppTheme.lightTheme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            _errorMessage.isNotEmpty
                ? _errorMessage
                : 'Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: _retryLoading,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                label: const Text('Retry'),
              ),
              ElevatedButton.icon(
                onPressed: _closeSession,
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                label: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDomainFromUrl(String url) {
    if (url.isEmpty) return _sessionData['domain'] as String;
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return _sessionData['domain'] as String;
    }
  }
}
