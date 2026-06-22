import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:flutter/material.dart';

/// Marks Ask Astrologer checkout screens active — used to suppress answer-ready popups.
mixin AskAstrologerFlowScreenMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    enterAskAstrologerFlowScreen();
  }

  @override
  void dispose() {
    exitAskAstrologerFlowScreen();
    super.dispose();
  }
}
