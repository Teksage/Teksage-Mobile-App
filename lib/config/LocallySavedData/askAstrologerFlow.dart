import 'dart:convert';

import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _flowKey = 'ask_astrologer_flow';

Future<void> writeAskAstrologerFlow(AskAstrologerFlowState state) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_flowKey, json.encode(state.toJson()));
}

Future<AskAstrologerFlowState?> readAskAstrologerFlow() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_flowKey);
  if (raw == null || raw.isEmpty) return null;
  try {
    return AskAstrologerFlowState.fromJson(
        json.decode(raw) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

Future<void> clearAskAstrologerFlow() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_flowKey);
}

int _askFlowScreenDepth = 0;
int? _viewingAskAnswerRequestId;

void enterAskAstrologerFlowScreen() => _askFlowScreenDepth++;

void exitAskAstrologerFlowScreen() {
  if (_askFlowScreenDepth > 0) _askFlowScreenDepth--;
}

bool get isAskAstrologerFlowScreenActive => _askFlowScreenDepth > 0;

void setViewingAskAnswerRequestId(int? requestId) {
  _viewingAskAnswerRequestId = requestId;
}

int? get viewingAskAnswerRequestId => _viewingAskAnswerRequestId;

/// Mirrors website `isAskAstrologerFlowPath` — skip popup only during active checkout screens.
Future<bool> shouldSuppressAnswerReadyPopup() async {
  return isAskAstrologerFlowScreenActive;
}
