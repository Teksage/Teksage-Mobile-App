import 'package:astro_prompt/Screens/auth/login_entry.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:flutter/material.dart';

/// Opens tabbed login on the Email tab (website alternate flow).
class LoginPageEmail extends StatelessWidget {
  const LoginPageEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginEntryPage(initialTab: LoginMethodTab.email);
  }
}
