import 'package:url_launcher/url_launcher.dart';

void launchGoogleMeet(String meetUrl) async {
  final Uri url = Uri.parse(meetUrl);

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
