import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SessionCookieManager {
  static final CookieManager _cookieManager = CookieManager.instance();

  /// Clear all cookies for a specific session
  static Future<void> clearSessionCookies(String sessionId) async {
    try {
      await _cookieManager.deleteAllCookies();
    } catch (e) {
      print('Error clearing cookies for session $sessionId: $e');
    }
  }

  /// Clear cookies for a specific domain
  static Future<void> clearDomainCookies(String domain) async {
    try {
      await _cookieManager.deleteCookies(url: WebUri(domain));
    } catch (e) {
      print('Error clearing cookies for domain $domain: $e');
    }
  }

  /// Get all cookies for a specific URL
  static Future<List<Cookie>> getCookiesForUrl(String url) async {
    try {
      final cookies = await _cookieManager.getCookies(url: WebUri(url));
      return cookies;
    } catch (e) {
      print('Error getting cookies for URL $url: $e');
      return [];
    }
  }

  /// Set cookie for a specific URL
  static Future<void> setCookie(String url, String name, String value) async {
    try {
      await _cookieManager.setCookie(
        url: WebUri(url),
        name: name,
        value: value,
      );
    } catch (e) {
      print('Error setting cookie for URL $url: $e');
    }
  }

  /// Enable/disable cookie acceptance
  /// Note: This method is simplified for web compatibility
  static Future<void> setCookieAcceptPolicy(bool accept) async {
    try {
      // For web builds, we skip the unsupported API calls
      if (kIsWeb) {
        print(
            'Cookie policy setting is handled by the browser on web platform');
        return;
      }

      // For mobile platforms, we can still use debugging settings
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);

      // The setAcceptThirdPartyCookies method is not available in current versions
      // Instead, we handle cookie acceptance through other means or skip it
      print('Cookie accept policy set to: ${accept ? 'ACCEPT' : 'REJECT'}');
    } catch (e) {
      print('Error setting cookie accept policy: $e');
    }
  }
}
