import 'dart:ui';

import 'package:astro_prompt/Components/Marathon/astroconnect_popup_dialog.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_list_page.dart';
import 'package:astro_prompt/Services/AstroConnect/astroconnect_popup_service.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows the latest published AstroConnect Pro event once per signed-in user.
class AstroConnectPopupPrompt {
  AstroConnectPopupPrompt._();

  static final AstroConnectPopupService _service = AstroConnectPopupService();
  static bool _popupOpen = false;
  static bool _handledSession = false;

  static Future<void> maybeShow(BuildContext context) async {
    if (_popupOpen || _handledSession || !context.mounted) return;
    _popupOpen = true;
    try {
      final accessToken = await getAccessToken();
      if (accessToken.trim().isEmpty || !context.mounted) return;

      final status = await _service.fetchStatus();
      if (!context.mounted || status == null) return;
      final event = status.event;
      if (!status.shouldShow || event == null || event.id <= 0) {
        _handledSession = true;
        return;
      }

      final openEvent = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close'.tr,
        barrierColor: Colors.black.withValues(alpha: 0.72),
        pageBuilder: (ctx, _, __) => AstroConnectPopupDialog(event: event),
        transitionBuilder: (ctx, animation, _, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );

      await _service.dismiss(event.id);
      _handledSession = true;
      if (openEvent == true) {
        Get.to(() => MarathonListPage(focusId: event.id));
      }
    } finally {
      _popupOpen = false;
    }
  }
}
