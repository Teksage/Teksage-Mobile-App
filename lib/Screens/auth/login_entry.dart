import 'package:astro_prompt/Screens/auth/login_page.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:flutter/material.dart';

/// Route wrapper — opens tabbed login (no country API; dial codes are fixed).
class LoginEntryPage extends StatelessWidget {
  final bool offAll;
  final LoginMethodTab initialTab;

  const LoginEntryPage({
    super.key,
    this.offAll = false,
    this.initialTab = LoginMethodTab.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LoginPage(initialTab: initialTab);
  }
}
