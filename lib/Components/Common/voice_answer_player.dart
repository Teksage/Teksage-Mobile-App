import 'dart:async';

import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class VoiceAnswerPlayer extends StatefulWidget {
  final String? filePath;
  final String? audioUrl;
  final int? durationSec;

  const VoiceAnswerPlayer({
    super.key,
    this.filePath,
    this.audioUrl,
    this.durationSec,
  }) : assert(filePath != null || audioUrl != null);

  @override
  State<VoiceAnswerPlayer> createState() => _VoiceAnswerPlayerState();
}

class _VoiceAnswerPlayerState extends State<VoiceAnswerPlayer> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _playing = false;
  bool _loading = true;

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  String get _sourceKey => widget.filePath ?? widget.audioUrl ?? '';

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void didUpdateWidget(covariant VoiceAnswerPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath ||
        oldWidget.audioUrl != widget.audioUrl) {
      _reloadPlayer();
    }
  }

  Future<void> _reloadPlayer() async {
    await _tearDownStreams();
    await _player.stop();
    if (!mounted) return;
    setState(() {
      _loading = true;
      _playing = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      if (widget.filePath != null) {
        await _player.setFilePath(widget.filePath!);
      } else if (widget.audioUrl != null) {
        await _player.setUrl(widget.audioUrl!);
      }

      if (widget.durationSec != null && widget.durationSec! > 0) {
        _duration = Duration(seconds: widget.durationSec!);
      }

      _durationSub = _player.durationStream.listen((value) {
        if (value != null && value > Duration.zero && mounted) {
          setState(() => _duration = value);
        }
      });
      _positionSub = _player.positionStream.listen((value) {
        if (mounted) setState(() => _position = value);
      });
      _stateSub = _player.playerStateStream.listen((state) {
        if (!mounted) return;
        setState(() => _playing = state.playing);
        if (state.processingState == ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.pause();
          setState(() {
            _position = Duration.zero;
            _playing = false;
          });
        }
      });

      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _tearDownStreams() async {
    await _durationSub?.cancel();
    await _positionSub?.cancel();
    await _stateSub?.cancel();
    _durationSub = null;
    _positionSub = null;
    _stateSub = null;
  }

  void _togglePlay() {
    if (_player.playing) {
      _player.pause();
      return;
    }
    if (_duration > Duration.zero && _position >= _duration) {
      _player.seek(Duration.zero);
    }
    _player.play();
  }

  void _seek(double ms) {
    _player.seek(Duration(milliseconds: ms.round()));
  }

  String _format(Duration value) {
    final totalSec = value.inSeconds;
    final mm = (totalSec ~/ 60).toString().padLeft(2, '0');
    final ss = (totalSec % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    _tearDownStreams();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: blackColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }

    final maxMs = _duration.inMilliseconds;
    final progressMs = maxMs > 0
        ? _position.inMilliseconds.clamp(0, maxMs).toDouble()
        : 0.0;

    return Semantics(
      label: _sourceKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: blackColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: blackColor.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: _togglePlay,
              icon: Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: blackColor,
              ),
              tooltip:
                  _playing ? 'Pause voice answer'.tr : 'Play voice answer'.tr,
            ),
            Expanded(
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12),
                      activeTrackColor: blackColor,
                      inactiveTrackColor: blackColor.withValues(alpha: 0.15),
                    ),
                    child: Slider(
                      min: 0,
                      max: maxMs > 0 ? maxMs.toDouble() : 1,
                      value: progressMs,
                      onChanged: maxMs > 0 ? _seek : null,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _format(_position),
                        style: TextStyle(
                          fontSize: 11,
                          color: blackColor.withValues(alpha: 0.55),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        _format(_duration),
                        style: TextStyle(
                          fontSize: 11,
                          color: blackColor.withValues(alpha: 0.55),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
