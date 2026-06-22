import 'package:astro_prompt/Components/Chat/whatsapp_ask_discovery_dialog.dart';
import 'package:astro_prompt/Services/FeatureDiscovery/feature_discovery_service.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';

/// App-wide feature discovery popup (any screen after login when eligible).
class FeatureDiscoveryPrompt {
  FeatureDiscoveryPrompt._();

  static final FeatureDiscoveryService _service = FeatureDiscoveryService();
  static bool _popupOpen = false;
  static bool _handledSession = false;

  static Future<void> maybeShow(BuildContext context) async {
    if (_popupOpen || _handledSession || !context.mounted) return;

    final accessToken = await getAccessToken();
    if (accessToken.trim().isEmpty) return;

    final status = await _service.fetchStatus();
    if (!context.mounted || status == null) return;

    if (status.dismissed) {
      _handledSession = true;
      return;
    }
    if (!status.shouldShowPopup) return;

    _popupOpen = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => WhatsAppAskDiscoveryDialog(
        onDismiss: () => Navigator.of(ctx).pop(),
      ),
    );

    if (!context.mounted) return;
    await _service.dismiss();
    _handledSession = true;
    _popupOpen = false;
  }
}
