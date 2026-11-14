import 'dart:convert';

import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_lead_page.dart';
import 'package:astro_prompt/Services/Marathon/astroconnect_lead_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

String marathonLeadStorageKey(Object? eventId) => 'teksage.astroconnect.lead.$eventId';

String marathonLeadResultKey(Object? eventId) => '${marathonLeadStorageKey(eventId)}.result';

String marathonLeadContactKey(Object? eventId) => '${marathonLeadStorageKey(eventId)}.contact';

const marathonLeadLastContactKey = 'teksage.astroconnect.lead.lastContact';

Future<void> markMarathonLeadNotified(Object? eventId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(marathonLeadStorageKey(eventId), true);
}

Future<void> clearMarathonLeadLocal(Object? eventId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(marathonLeadStorageKey(eventId));
  await prefs.remove(marathonLeadResultKey(eventId));
  await prefs.remove(marathonLeadContactKey(eventId));
}

Future<void> saveMarathonLeadResult(
  Object? eventId,
  Map<String, dynamic> result, {
  String? countryCode,
  String? mobileNumber,
  String? name,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(marathonLeadStorageKey(eventId), true);
  await prefs.setString(marathonLeadResultKey(eventId), jsonEncode(result));
  final contact = <String, String>{
    if ((countryCode ?? '').trim().isNotEmpty) 'country_code': countryCode!.replaceAll('+', '').trim(),
    if ((mobileNumber ?? '').trim().isNotEmpty)
      'mobile_number': mobileNumber!.replaceAll(RegExp(r'\D'), ''),
    if ((name ?? '').trim().isNotEmpty) 'name': name!.trim(),
  };
  if (contact.isNotEmpty) {
    final encoded = jsonEncode(contact);
    await prefs.setString(marathonLeadContactKey(eventId), encoded);
    await prefs.setString(marathonLeadLastContactKey, encoded);
  }
}

Future<bool> isMarathonLeadNotified(Object? eventId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(marathonLeadStorageKey(eventId)) == true;
}

Future<Map<String, dynamic>?> loadMarathonLeadResult(Object? eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(marathonLeadResultKey(eventId));
  if (raw == null || raw.isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } catch (_) {}
  return null;
}

Future<Map<String, String>?> loadMarathonLeadContact(Object? eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(marathonLeadContactKey(eventId)) ??
      prefs.getString(marathonLeadLastContactKey);
  if (raw == null || raw.isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry('$key', '$value'));
    }
  } catch (_) {}
  return null;
}

/// Resolves card CTA from server when phone is known; local flag is cache only.
Future<bool> resolveMarathonLeadNotified(Object? eventId) async {
  final local = await isMarathonLeadNotified(eventId);
  final cached = await loadMarathonLeadResult(eventId);
  final contact = await loadMarathonLeadContact(eventId);
  final dial = (contact?['country_code'] ?? '').replaceAll(RegExp(r'\D'), '');
  final phone = (contact?['mobile_number'] ?? '').replaceAll(RegExp(r'\D'), '');

  // Old installs only set a bool (no phone) — cannot verify, so drop stale CTA.
  if (phone.length < 7) {
    if (local || cached != null) {
      await clearMarathonLeadLocal(eventId);
    }
    return false;
  }

  try {
    final row = await AstroConnectLeadService().lookupLead(
      countryCode: dial.isEmpty ? '91' : dial,
      mobileNumber: phone,
      sourceMarathonId: int.tryParse('$eventId') ?? 0,
    );
    if (row != null) {
      await saveMarathonLeadResult(
        eventId,
        row,
        countryCode: dial.isEmpty ? '91' : dial,
        mobileNumber: phone,
        name: contact?['name'] ?? row['name']?.toString(),
      );
      return true;
    }
    // Server has no lead for this phone+event — drop stale local "View notification".
    await clearMarathonLeadLocal(eventId);
    return false;
  } catch (_) {
    // Network error: keep verified cache only when we still have a result payload.
    return local && cached != null;
  }
}

/// Card CTA — opens the lead form / success page (inline with Book a Slot).
class MarathonLeadCapture extends StatefulWidget {
  const MarathonLeadCapture({super.key, required this.event, this.expanded = false});

  final Map<String, dynamic> event;
  final bool expanded;

  @override
  State<MarathonLeadCapture> createState() => _MarathonLeadCaptureState();
}

class _MarathonLeadCaptureState extends State<MarathonLeadCapture> {
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void didUpdateWidget(covariant MarathonLeadCapture oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event['id'] != widget.event['id']) {
      _restore();
    }
  }

  Future<void> _restore() async {
    final eventId = widget.event['id'];
    final local = await isMarathonLeadNotified(eventId);
    if (mounted) setState(() => _notified = local);

    final notified = await resolveMarathonLeadNotified(eventId);
    if (!mounted) return;
    setState(() => _notified = notified);
  }

  Future<void> _open() async {
    await Get.to(() => MarathonLeadPage(event: widget.event));
    if (!mounted) return;
    await _restore();
  }

  @override
  Widget build(BuildContext context) {
    final listed = widget.event['status'] == 'published' ||
        widget.event['status'] == 'ended' ||
        widget.event['admin_ended'] == true;
    if (!listed) return const SizedBox.shrink();

    return MarathonActionButton(
      label: _notified ? 'View notification'.tr : 'Notify me'.tr,
      soft: _notified,
      expanded: widget.expanded,
      onTap: _open,
    );
  }
}
