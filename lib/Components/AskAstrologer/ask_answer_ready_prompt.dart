import 'dart:async';

import 'package:astro_prompt/Components/AskAstrologer/ask_answer_ready_dialog.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Notifies the answer-ready prompt to re-check (mirrors website pathname changes).
class AskAnswerReadyScheduler {
  static VoidCallback? _check;

  static void register(VoidCallback check) => _check = check;

  static void unregister() => _check = null;

  static void notifyRouteChanged() => _check?.call();
}

/// Polls for unanswered "answer ready" popups — mirrors website `AskAnswerReadyPrompt`.
class AskAnswerReadyPrompt extends StatefulWidget {
  final Widget child;
  const AskAnswerReadyPrompt({super.key, required this.child});

  @override
  State<AskAnswerReadyPrompt> createState() => _AskAnswerReadyPromptState();
}

class _AskAnswerReadyPromptState extends State<AskAnswerReadyPrompt>
    with WidgetsBindingObserver {
  static const _pollInterval = Duration(seconds: 45);

  Timer? _pollTimer;
  Worker? _navWorker;
  bool _checking = false;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AskAnswerReadyScheduler.register(_checkPending);
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
    AskAnswerReadyScheduler.unregister();
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPending();
    }
  }

  BuildContext? _navigatorContext() {
    return Get.key.currentContext ?? Get.overlayContext;
  }

  Future<void> _checkPending() async {
    if (!mounted || _checking || _dialogOpen) return;
    _checking = true;
    try {
      final token = await getAccessToken();
      if (token.isEmpty || !mounted) return;
      final isCustomer = await getUserType();
      if (!isCustomer || !mounted) return;
      if (await shouldSuppressAnswerReadyPopup() || !mounted) return;

      final pending = await AskAstrologerService().fetchPendingAnswerPopup();
      if (!mounted || pending == null) return;
      if (viewingAskAnswerRequestId == pending.id) return;

      final dialogContext = _navigatorContext();
      if (dialogContext == null || !dialogContext.mounted) return;

      _dialogOpen = true;
      await showAskAnswerReadyDialog(dialogContext, pending);
    } finally {
      _dialogOpen = false;
      _checking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
