import 'dart:convert';
import 'dart:io';

import 'package:astro_prompt/Services/Analytics/facebookAppEventsService.dart';
import 'package:astro_prompt/Services/PartnerService/partnerRefStorage.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

const _kInstallIdKey = 'teksage_app_install_id';
const _kInstallReportedKey = 'teksage_app_install_reported';
const _kInstallReportedSourceKey = 'teksage_app_install_reported_source';
const _kInstallReportedCampaignKey = 'teksage_app_install_reported_campaign';
const _kInstallSourceKey = 'teksage_app_install_source';
const _kInstallCampaignKey = 'teksage_app_install_campaign';
const _kInstallAttachedKey = 'teksage_app_install_attached';
const _kDeepLinkChannel = MethodChannel('com.venzo.astroPrompt/deeplink');

/// Persists install_id and reports first-open + login attach to Teksage backend.
class InstallAttributionService {
  InstallAttributionService._();
  static final InstallAttributionService instance =
      InstallAttributionService._();

  /// Initialize deep link listeners (cold-start intent and runtime intent)
  /// and report attribution.
  Future<void> initDeepLinkAndAttribution() async {
    // 1. Listen for runtime deep links while app is open
    _kDeepLinkChannel.setMethodCallHandler((call) async {
      if (kDebugMode) print('DeepLink channel method: ${call.method}, args: ${call.arguments}');
      if (call.method == 'onDeepLink' && call.arguments is String) {
        final uriStr = call.arguments as String;
        final uri = Uri.tryParse(uriStr);
        if (kDebugMode) print('Parsed runtime DeepLink URI: $uri');
        if (uri != null) {
          await captureAttributionFromUri(uri);
          await PartnerRefStorage.captureFromUri(uri);
          await reportFirstOpenIfNeeded();
        }
      }
    });

    // 2. Check initial native link on cold start
    Uri? launchUri;
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final String? initial =
            await _kDeepLinkChannel.invokeMethod<String>('getInitialLink');
        if (kDebugMode) print('Initial native deep link: $initial');
        if (initial != null && initial.isNotEmpty) {
          launchUri = Uri.tryParse(initial);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error getting initial deep link: $e');
    }

    launchUri ??= Uri.base;
    if (kDebugMode) print('Executing attribution on launchUri: $launchUri');

    await captureAttributionFromUri(launchUri);
    await PartnerRefStorage.captureFromUri(launchUri);
    await reportFirstOpenIfNeeded();
  }

  String _newInstallId() {
    final r = Random.secure();
    String hex(int n) =>
        List.generate(n, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'))
            .join();
    return '${hex(4)}-${hex(2)}-${hex(2)}-${hex(2)}-${hex(6)}';
  }

  Future<String> getOrCreateInstallId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_kInstallIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = _newInstallId();
    await prefs.setString(_kInstallIdKey, id);
    return id;
  }

  /// Capture Facebook / UTM signals from deep link or launch URI.
  Future<void> captureAttributionFromUri(Uri? uri) async {
    if (uri == null) return;
    final prefs = await SharedPreferences.getInstance();
    final params = <String, String>{...uri.queryParameters};

    final redirect = uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      try {
        final nested = Uri.parse(
          redirect.startsWith('http')
              ? redirect
              : 'https://local.invalid$redirect',
        );
        params.addAll(nested.queryParameters);
      } catch (_) {}
    }

    final utmSource = (params['utm_source'] ?? '').toLowerCase();
    final utmMedium = (params['utm_medium'] ?? '').toLowerCase();
    final fbclid = params['fbclid'];
    final rawCampaign = params['utm_campaign'] ?? params['campaign'];
    final campaign = rawCampaign?.replaceAll('\\', '').trim();

    final rawSource = (params['utm_source'] ?? '').toLowerCase();
    String detectedSource = 'unknown';
    if (rawSource.contains('instagram') || rawSource.contains('ig')) {
      detectedSource = 'instagram';
    } else if (rawSource.contains('facebook') ||
        rawSource.contains('fb') ||
        rawSource.contains('meta') ||
        (fbclid != null && fbclid.isNotEmpty)) {
      detectedSource = 'facebook';
    } else if (rawSource.contains('organic') || utmMedium.contains('organic')) {
      detectedSource = 'organic';
    } else if (rawSource.isNotEmpty) {
      detectedSource = rawSource;
    }

    bool changed = false;
    if (detectedSource != 'unknown') {
      final prevSource = prefs.getString(_kInstallSourceKey);
      if (prevSource != detectedSource) {
        await prefs.setString(_kInstallSourceKey, detectedSource);
        changed = true;
      }
    }

    if (campaign != null && campaign.isNotEmpty) {
      final prevCamp = prefs.getString(_kInstallCampaignKey);
      if (prevCamp != campaign) {
        await prefs.setString(_kInstallCampaignKey, campaign);
        changed = true;
      }
    }

    if (changed) {
      // Force re-report to sync new campaign / source with backend.
      await prefs.setBool(_kInstallReportedKey, false);
    }
  }

  Future<Map<String, String?>> _readAttribution(SharedPreferences prefs) async {
    final source = prefs.getString(_kInstallSourceKey) ?? 'unknown';
    final campaign = prefs.getString(_kInstallCampaignKey);
    return {
      'source': source,
      'campaign': campaign,
      'medium': (source == 'facebook' || source == 'instagram') ? 'paid' : null,
    };
  }

  /// Call once on app start after Firebase init.
  Future<void> reportFirstOpenIfNeeded() async {
    try {
      await FacebookAppEventsService.instance.activate();
      final prefs = await SharedPreferences.getInstance();
      final installId = await getOrCreateInstallId();
      final attr = await _readAttribution(prefs);
      final source = attr['source'] ?? 'unknown';
      final campaign = attr['campaign'];
      final already = prefs.getBool(_kInstallReportedKey) ?? false;
      final lastSource = prefs.getString(_kInstallReportedSourceKey);
      final lastCampaign = prefs.getString(_kInstallReportedCampaignKey);

      if (already && lastSource == source && lastCampaign == campaign) return;

      final body = {
        'install_id': installId,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'source': source,
        if (campaign != null && campaign.isNotEmpty) 'campaign': campaign,
        if (attr['medium'] != null) 'medium': attr['medium'],
      };

      final response = await http.post(
        Uri.parse(ApiEndpoint.analyticsInstall),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await prefs.setBool(_kInstallReportedKey, true);
        await prefs.setString(_kInstallReportedSourceKey, source);
        if (campaign != null && campaign.isNotEmpty) {
          await prefs.setString(_kInstallReportedCampaignKey, campaign);
        }
        if (kDebugMode) {
          print('✅ Install reported to backend: source=$source, campaign=$campaign, installId=$installId');
        }
      } else if (kDebugMode) {
        print('❌ Install report failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) print('Install report error: $e');
    }
  }

  /// After successful OTP login — attach user + Meta CompleteRegistration.
  Future<void> onLoginSuccess({required String userId}) async {
    try {
      await FacebookAppEventsService.instance.setUserId(userId);
      await FacebookAppEventsService.instance
          .logCompletedRegistration(method: 'otp');

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_kInstallAttachedKey) == true) return;

      final installId = await getOrCreateInstallId();
      final accessToken = await getAccessToken();
      if (accessToken.isEmpty) return;

      final response = await http.post(
        Uri.parse(ApiEndpoint.analyticsAttachUser),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'install_id': installId}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await prefs.setBool(_kInstallAttachedKey, true);
      } else if (kDebugMode) {
        print('Install attach failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) print('Install attach error: $e');
    }
  }

  Future<void> onLogout() async {
    await FacebookAppEventsService.instance.clearUserId();
    // Keep install_id; clear only attach flag so next login can re-link if needed.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kInstallAttachedKey);
  }
}
