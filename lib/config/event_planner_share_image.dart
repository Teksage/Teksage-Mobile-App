import 'dart:io';

import 'package:astro_prompt/config/event_planner_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class EventPlannerShareImage {
  static Future<void> share({
    required ScreenshotController controller,
    required String pageUrl,
  }) async {
    final bytes = await controller.capture(pixelRatio: 2);
    if (bytes == null || bytes.isEmpty) {
      throw StateError('capture_failed');
    }
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${EventPlannerConfig.shareImageFileName}';
    await File(path).writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        text: EventPlannerConfig.buildShareCaption(pageUrl),
        files: [XFile(path, mimeType: 'image/png')],
      ),
    );
  }
}
