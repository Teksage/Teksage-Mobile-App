import 'dart:async';

import 'package:astro_prompt/Components/Consultation-User/consultation_answers_ready_dialog.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Polls for consultation answers-ready popup — mirrors website prompt.
class ConsultationAnswersReadyPrompt extends StatefulWidget {
  final Widget child;
  const ConsultationAnswersReadyPrompt({super.key, required this.child});

  @override
  State<ConsultationAnswersReadyPrompt> createState() =>
      _ConsultationAnswersReadyPromptState();
}

class _ConsultationAnswersReadyPromptState
    extends State<ConsultationAnswersReadyPrompt> with WidgetsBindingObserver {
  static const _pollInterval = Duration(seconds: 45);

  Timer? _pollTimer;
  Worker? _navWorker;
  bool _checking = false;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Get.isRegistered<BottomNavController>()) {
      _navWorker = ever(
        Get.find<BottomNavController>().currentIndex,
        (_) => _checkPending(),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPending());
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkPending());
  }

  @override
  void dispose() {
    _navWorker?.dispose();
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkPending();
  }

  BuildContext? _navigatorContext() =>
      Get.key.currentContext ?? Get.overlayContext;

  Future<void> _checkPending() async {
    if (!mounted || _checking || _dialogOpen) return;
    _checking = true;
    try {
      final token = await getAccessToken();
      if (token.isEmpty || !mounted) return;
      final isCustomer = await getUserType();
      if (!isCustomer || !mounted) return;

      final pending =
          await AstroUserEventService().fetchPendingAnswersPopup();
      if (!mounted || pending == null) return;
      final eventId = pending['id'] as int?;
      if (eventId == null) return;
      if (viewingConsultationAnswersEventId == eventId) return;

      final dialogContext = _navigatorContext();
      if (dialogContext == null || !dialogContext.mounted) return;

      _dialogOpen = true;
      await showConsultationAnswersReadyDialog(dialogContext, pending);
    } finally {
      _dialogOpen = false;
      _checking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
