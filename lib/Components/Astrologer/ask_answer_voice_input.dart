import 'dart:async';
import 'dart:io';

import 'package:astro_prompt/Components/Chat/waveProgress.dart';
import 'package:astro_prompt/Components/Common/voice_answer_player.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AskAnswerVoiceInput extends StatefulWidget {
  final File? voiceFile;
  final int? voiceDurationSec;
  final ValueChanged<File?> onVoiceChanged;
  final ValueChanged<int?> onDurationChanged;
  final bool disabled;

  const AskAnswerVoiceInput({
    super.key,
    required this.voiceFile,
    required this.voiceDurationSec,
    required this.onVoiceChanged,
    required this.onDurationChanged,
    this.disabled = false,
  });

  @override
  State<AskAnswerVoiceInput> createState() => _AskAnswerVoiceInputState();
}

class _AskAnswerVoiceInputState extends State<AskAnswerVoiceInput> {
  final AudioRecorder _recorder = AudioRecorder();
  static const _waveformLength = 20;

  bool _recording = false;
  DateTime? _startedAt;
  int _elapsedSec = 0;
  Timer? _elapsedTimer;
  StreamSubscription<Amplitude>? _ampSub;
  late List<double> _amplitudes = List.filled(_waveformLength, 0.0);
  int _ampIndex = 0;

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _ampSub?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  double _normalizeAmplitude(double db) {
    const silenceDb = -35.0;
    if (db < silenceDb) return 0.1;
    if (db > 0) return 1.0;
    return (db - silenceDb) / -silenceDb;
  }

  Future<void> _startRecording() async {
    if (widget.disabled || !await _recorder.hasPermission()) return;
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/ask_answer_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _amplitudes = List.filled(_waveformLength, 0.0);
    _ampIndex = 0;

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    _ampSub = _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 60))
        .listen((amp) {
      if (!mounted) return;
      setState(() {
        _amplitudes[_ampIndex] = _normalizeAmplitude(amp.current);
        _ampIndex = (_ampIndex + 1) % _waveformLength;
      });
    });

    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_recording) return;
      setState(() => _elapsedSec++);
    });

    setState(() {
      _recording = true;
      _startedAt = DateTime.now();
      _elapsedSec = 0;
    });
  }

  Future<void> _cancelRecording() async {
    await _recorder.stop();
    await _ampSub?.cancel();
    _ampSub = null;
    _elapsedTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _recording = false;
      _startedAt = null;
      _elapsedSec = 0;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    final started = _startedAt;
    await _ampSub?.cancel();
    _ampSub = null;
    _elapsedTimer?.cancel();
    setState(() {
      _recording = false;
      _startedAt = null;
      _elapsedSec = 0;
    });
    if (path == null) return;
    final duration = started == null
        ? null
        : DateTime.now().difference(started).inSeconds;
    widget.onVoiceChanged(File(path));
    widget.onDurationChanged(duration);
  }

  void _removeVoice() {
    widget.onVoiceChanged(null);
    widget.onDurationChanged(null);
  }

  String _formatElapsed(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  String get _fileLabel {
    final file = widget.voiceFile;
    if (file == null) return '';
    return file.path.split(Platform.pathSeparator).last;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final displayAmps = List<double>.generate(
      _waveformLength,
      (i) => _amplitudes[(_ampIndex + i) % _waveformLength],
    );

    if (_recording) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mainColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: mainColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _cancelRecording,
                  child: SvgPicture.asset(chatDeleteIcon, width: 24, height: 24),
                ),
                SizedBox(width: 8),
                Text(
                  _formatElapsed(_elapsedSec),
                  style: TextStyle(
                    fontSize: util.fontSize18,
                    fontFamily: AppFont.get(FontType.medium),
                    color: blackColor.withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 64,
                    child: CustomPaint(
                      painter: WaveformBarsPainter(displayAmps, color: mainColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _stopRecording,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: mainColor, width: 1.36),
                      color: mainColor,
                    ),
                    child: SvgPicture.asset(
                      stopRecordChat,
                      width: 20,
                      height: 20,
                      colorFilter:
                          const ColorFilter.mode(whiteColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Tap stop when finished'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: util.fontSize12,
                color: mainColor,
                fontFamily: AppFont.get(FontType.medium),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: widget.disabled ? null : _startRecording,
              icon: Icon(Icons.mic, size: 16, color: mainColor),
              label: Text(
                widget.voiceFile == null ? 'Record voice'.tr : 'Re-record'.tr,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: mainColor,
                side: BorderSide(color: mainColor),
              ),
            ),
            if (widget.voiceFile != null)
              TextButton(
                onPressed: widget.disabled ? null : _removeVoice,
                child: Text(
                  'Remove'.tr,
                  style: TextStyle(color: errorColor),
                ),
              ),
          ],
        ),
        if (widget.voiceFile != null) ...[
          SizedBox(height: util.height10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: blackColor.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: util.fontSize12,
                    color: blackColor.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: util.height10),
                VoiceAnswerPlayer(
                  filePath: widget.voiceFile!.path,
                  durationSec: widget.voiceDurationSec,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
