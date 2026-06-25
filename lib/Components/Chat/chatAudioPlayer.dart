import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class ChatAudioPlayer extends StatefulWidget {
  final String audioBase64;

  const ChatAudioPlayer({super.key, required this.audioBase64});

  @override
  State<ChatAudioPlayer> createState() => _ChatAudioPlayerState();
}

class _ChatAudioPlayerState extends State<ChatAudioPlayer> with WidgetsBindingObserver{
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _playing = false;
  bool _autoPlayed = false;
  String? _tempFilePath;

  List<double> _waveformBars = [];

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _initAudio();
    WidgetsBinding.instance.addObserver(this);
    final rand = Random();
    _waveformBars = List.generate(
      20,
      (_) => rand.nextDouble() * 40,
    );
  }

  @override
  void didUpdateWidget(covariant ChatAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioBase64 != oldWidget.audioBase64) {
      _resetPlayerForNewAudio();
    }
  }

  Future<void> _resetPlayerForNewAudio() async {
    try {
      await _player.stop();
    } catch (_) {}
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();

    if (_tempFilePath != null) {
      try {
        final f = File(_tempFilePath!);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
      _tempFilePath = null;
    }

    setState(() {
      _duration = Duration.zero;
      _position = Duration.zero;
      _playing = false;
      _autoPlayed = false;
    });

    await _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      final bytes = base64Decode(widget.audioBase64);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await file.writeAsBytes(bytes);
      _tempFilePath = file.path;
      _autoPlayed = false;

      await _player.setFilePath(_tempFilePath!);

      _durationSub?.cancel();
      _positionSub?.cancel();
      _playerStateSub?.cancel();

      _durationSub = _player.durationStream.listen((d) {
        if (d != null && mounted) setState(() => _duration = d);
      });

      _positionSub = _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });

      _playerStateSub = _player.playerStateStream.listen((state) async{
        setState(() {
          _playing = state.playing;
        });

        if (state.processingState == ProcessingState.ready && !_playing && !_autoPlayed) {
          _autoPlayed = true;
          try {
            await _player.play();
          } catch (_) {}
        }

        if (state.processingState == ProcessingState.completed) {
          _autoPlayed = true;
          await _player.seek(Duration.zero);
          await _player.pause();
          setState(() {
            _position = Duration.zero;
            _playing = false;
          });
        }
      });
    } catch (e, st) {
      debugPrint("Audio init error: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  void _togglePlay() {
    if (_player.playing) {
      _player.pause();
    } else {
      if (_position >= _duration && _duration > Duration.zero) {
        _player.seek(Duration.zero);
      }
      _player.play();
    }
  }

  void _seek(double value) {
    final position = Duration(milliseconds: value.toInt());
    _player.seek(position);
  }

  String _formatTime(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$mm:$ss";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    if (_tempFilePath != null) {
      try {
        final f = File(_tempFilePath!);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _duration - _position;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: whiteColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: whiteColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (_waveformBars.isEmpty) return const SizedBox();

                        final barWidth = 3.0;
                        final totalBars = _waveformBars.length;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(totalBars, (i) {
                            if (_duration.inMilliseconds == 0) return Container();

                            final barTime = _duration.inMilliseconds * (i / totalBars);
                            final isPlayed = barTime <= _position.inMilliseconds;

                            return Container(
                              width: barWidth,
                              height: _waveformBars[i].clamp(6, 40),
                              decoration: BoxDecoration(
                                color: isPlayed ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Slider(
                        min: 0.0,
                        max: _duration.inMilliseconds.toDouble(),
                        value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                        onChanged: (value) => _seek(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(remaining < Duration.zero ? Duration.zero : remaining),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      _formatTime(_duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: whiteColor.withValues(alpha: 0.3), width: 0.86)),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  _playing ? Icons.pause : Icons.play_arrow_rounded,
                  color: Platform.isAndroid ? mainColor : iosMainColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
