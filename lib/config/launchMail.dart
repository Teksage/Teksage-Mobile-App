import 'package:url_launcher/url_launcher.dart';

Future<void> launchSupportEmail({
  String subject = 'Privacy Policy Enquiry',
  String body = '',
}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'support@teksage.app',
    queryParameters: {
      if (subject.isNotEmpty) 'subject': subject,
      if (body.isNotEmpty) 'body': body,
    },
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    throw 'Could not launch mail app';
  }
}
