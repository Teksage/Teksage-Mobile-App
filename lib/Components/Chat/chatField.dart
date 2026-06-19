import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:astro_prompt/Components/Chat/animatedHintText.dart';
import 'package:astro_prompt/Components/Chat/chatAvatar.dart';
import 'package:astro_prompt/Components/Chat/recordTimer.dart';
import 'package:astro_prompt/Components/Chat/waveProgress.dart';
import 'package:astro_prompt/Model/chatAvatarModel.dart';
import 'package:astro_prompt/Screens/Chat/chatAvatar.dart';
import 'package:astro_prompt/Screens/Chat/chatStyle.dart';
import 'package:astro_prompt/Services/ChatService/audioTranscriptionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/capitalizeFirstLetter.dart';
import 'package:astro_prompt/config/LocallySavedData/chatLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/chatPreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/record.dart' as rec;
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';


class ChatInputField extends StatefulWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final VoidCallback sendMessage;
  final Function(String) onStyleSelected;
  final Function(String) avatar;
  final Function(String) selectedLanguage;
  final Function(String) onMessageModeChanged;
  final bool isPremium;
  final bool isInputDisabled;

  const ChatInputField({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.sendMessage,
    required this.onStyleSelected,
    required this.avatar,
    required this.isPremium,
    required this.isInputDisabled,
    required this.selectedLanguage,
    required this.onMessageModeChanged,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  double containerHeight = 50.0;
  AvatarOption? selectedAvatar;
  StyleOption? selectedStyle;
  String? selectedLanguage;
  RecordTimer? _recordTimer;
  int _remainingTime = 20;
  String messageMode = '';
  String chatLanguage = 'english';
  String? customLanguage;
  bool _isApplyingTranscript = false;
  late final VoidCallback _messageControllerListener;

  final rec.AudioRecorder _recorder = rec.AudioRecorder();
  final int _waveformLength = 20;
  late List<double> _amplitudes = List.filled(_waveformLength, 0.0);
  int _ampIndex = 0;
  StreamSubscription<Amplitude>? _ampSub;

  bool _isRecording = false;
  String? _tempFilePath;
  bool _isConverting = false;

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  final List<AvatarOption> avatars = [
    AvatarOption(
      imagePath: chatSeeker,
      title: 'The Seeker',
      description:
          'Ideal for those who want in-depth astrological analysis and clear reasoning',
    ),
    AvatarOption(
      imagePath: chatLuminary,
      title: 'The Luminary',
      description:
          'Ideal for those who seek joyful and engaging astrology guidance',
    ),
    AvatarOption(
      imagePath: chatGuardian,
      title: 'The Guardian',
      description:
          'Ideal for those looking for reassurance and personal connection in predictions',
    ),
    AvatarOption(
      imagePath: chatPathFinder,
      title: 'The Pathfinder',
      description:
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadChatLanguage();
    _recordTimer = RecordTimer(
      timerStart: (timeLeft) {
        setState(() {
          _remainingTime = timeLeft;
        });
      },
      timerStop: () async {
        await _stopRecording();
      },
    );
    _messageControllerListener = _onMessageControllerChanged;
    widget.messageController.addListener(_messageControllerListener);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_messageControllerListener);
    _recordTimer?.stop();
    _recorder.stop();
    _ampSub?.cancel();
    super.dispose();
  }

  AvatarOption? getAvatarOptionByTitle(String title) {
    return avatars.firstWhere(
      (a) => a.title.toLowerCase() == title.toLowerCase(),
      orElse: () => avatars.first,
    );
  }

  StyleOption getStyleOptionByName(String name) {
    return name == 'long'
        ? StyleOption(name: 'Explanatory', icon: chatExplain)
        : StyleOption(name: 'Concise', icon: chatConcise);
  }

  Future<void> _loadChatLanguage() async {
    final lang = await getChatLanguage();
    setState(() {
      chatLanguage = lang.isEmpty ? 'English' : lang;
      customLanguage = lang.isEmpty ? null : lang;
      selectedLanguage = lang.isEmpty ? 'English' : lang;
    });
    widget.selectedLanguage(chatLanguage.toLowerCase());
  }

  void _onMessageControllerChanged() {
    if (_isApplyingTranscript) return;

    if (_isRecording) return;

    final text = widget.messageController.text.trim();

    if (text.isEmpty) {
      if (messageMode != '') {
        setState(() {
          messageMode = '';
        });
      }
      return;
    }

    if (messageMode == 'audio') {
      if (messageMode != 'hybrid') {
        setState(() {
          messageMode = 'hybrid';
        });
      }
      // Otherwise keep it as 'audio'
      return;
    }

    if (messageMode != 'hybrid' && messageMode != 'audio') {
      setState(() {
        messageMode = 'text';
      });
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final style = prefs.getString("chat_style");
    final avatar = prefs.getString("chat_avatar");
    final lang = prefs.getString("chat_lang");

    setState(() {
      if (style != null) selectedStyle = getStyleOptionByName(style);
      if (avatar != null) selectedAvatar = getAvatarOptionByTitle(avatar);
      if (lang != null) selectedLanguage = lang;
    });

    if (style != null) widget.onStyleSelected(style);
    if (avatar != null) widget.avatar(avatar);
    if (lang != null) widget.selectedLanguage(lang);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isStyleMissing = style == null || style.isEmpty;
      final isAvatarMissing = avatar == null || avatar.isEmpty;
      if (isStyleMissing && isAvatarMissing) {
        final styleResult = await Get.to(() => const ChatStyle());
        if (styleResult != null) {
          await prefs.setString("chat_style", styleResult);
          setState(() => selectedStyle = getStyleOptionByName(styleResult));
          widget.onStyleSelected(styleResult);
          final avatarResult = await Get.to(() => const ChatAvatar());
          if (avatarResult != null) {
            await prefs.setString("chat_avatar", avatarResult);
            setState(
                () => selectedAvatar = getAvatarOptionByTitle(avatarResult));
            widget.avatar(avatarResult);
            final currentLang = selectedLanguage ?? 'English';
            await saveChatPreference(styleResult, avatarResult, currentLang);
            AuthService().updateChatFormat(
              format: styleResult,
              avatar: avatarResult,
              chatLanguage: currentLang,
            );
          }
        }
      } else if (isStyleMissing) {
        final styleResult = await Get.to(() => const ChatStyle());
        if (styleResult != null) {
          await prefs.setString("chat_style", styleResult);
          setState(() => selectedStyle = getStyleOptionByName(styleResult));
          widget.onStyleSelected(styleResult);
          AuthService().updateChatFormat(
            format: styleResult,
            avatar: selectedAvatar?.title.toLowerCase() ?? '',
            chatLanguage: selectedLanguage ?? 'English',
          );
        }
      } else if (isAvatarMissing) {
        final avatarResult = await Get.to(() => const ChatAvatar());
        if (avatarResult != null) {
          await prefs.setString("chat_avatar", avatarResult);
          setState(() => selectedAvatar = getAvatarOptionByTitle(avatarResult));
          widget.avatar(avatarResult);
          AuthService().updateChatFormat(
            format: selectedStyle?.name == 'Explanatory'
                ? 'long'
                : selectedStyle?.name == 'Concise'
                    ? 'short'
                    : '',
            avatar: avatarResult,
            chatLanguage: selectedLanguage ?? 'English',
          );
        }
      }
    });
  }

  String sanitizeMessage(String input) {
    if (input.isEmpty) return input;
    final removedInvisible = input.replaceAll(
      RegExp(
        r'['
        r'\u200B-\u200D'
        r'\uFEFF'
        r'\u2060'
        r'\u00AD'
        r'\u202A-\u202E'
        r'\u2066-\u2069'
        r']',
      ),
      '',
    );
    final removedControls = removedInvisible.replaceAll(
      RegExp(r'[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]'),
      '',
    );
    return removedControls.trim();
  }

  double _normalizeAmplitude(double db) {
    const silenceDb = -35.0;
    if (db < silenceDb) return 0.1;
    if (db > 0) return 1.0;
    return (db - silenceDb) / -silenceDb;
  }

  Future<void> _startRecording() async {
    if (_isConverting || _isRecording) return;

    if (await _recorder.hasPermission()) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_recording.wav';

      _amplitudes = List.filled(_waveformLength, 0.0);
      _ampIndex = 0;
      await _recorder.start(
        rec.RecordConfig(
          encoder: rec.AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 16000,
        ),
        path: filePath,
      );

      _ampSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 60))
          .listen((amp) {
        setState(() {
          final normalized = _normalizeAmplitude(amp.current);
          _amplitudes[_ampIndex] = normalized;
          _ampIndex = (_ampIndex + 1) % _waveformLength;
        });
      });

      setState(() {
        _isRecording = true;
        _tempFilePath = filePath;
        _isConverting = false;
        messageMode = 'audio';
      });

      _recordTimer?.start();
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    final path = await _recorder.stop();
    _recordTimer?.stop();
    await _ampSub?.cancel();
    _ampSub = null;
    setState(() {
      _isConverting = true;
    });

    if (path != null) {
      await Future.delayed(Duration(milliseconds: 300));
      final file = File(path);
      if (await file.exists() && await file.length() > 0) {
        await _sendAudioToBackend(path);
      } else {
        debugPrint('Recording file not ready or empty');
      }
    }
  }

  Future<void> _sendAudioToBackend(String filePath) async {
    setState(() => _isConverting = true);
    try {
      final transcript = await AudioTranscriptionService.transcribeAudio(
          filePath, chatLanguage);

      if (transcript != null && transcript.isNotEmpty) {
        _isApplyingTranscript = true;
        widget.messageController.text = transcript;
        Future.microtask(() {
          _isApplyingTranscript = false;
        });
        setState(() {
          messageMode = 'audio';
        });
        print('🎤 Transcription complete - messageMode set to: audio');
        // Notify parent that message mode is audio
        widget.onMessageModeChanged('audio');
      } else {
        debugPrint('No transcript received');
      }
    } catch (e) {
      debugPrint('Transcription error: $e');
    } finally {
      setState(() {
        _isConverting = false;
        _isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final displayAmps = List<double>.generate(
      _waveformLength,
      (i) => _amplitudes[(_ampIndex + i) % _waveformLength],
    );

    void showStyleModal(
        BuildContext context, Function(StyleOption) onSelected) {
      final util = MyUtility(context);

      showGeneralDialog(
        barrierLabel: '',
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.bottomRight,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: util.responsiveWidth(0.6),
                height: util.responsiveHeight(0.1306),
                margin: EdgeInsets.only(
                    bottom: 60,
                    right: util.responsiveWidth(0.346),
                    left: util.width20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withValues(alpha: 0.17),
                      blurRadius: 23,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          // onSelected('long');
                          onSelected(StyleOption(
                              name: 'Explanatory', icon: chatExplain));
                        },
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              chatExplain,
                              colorFilter: ColorFilter.mode(
                                Platform.isAndroid ? mainColor : iosMainColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Explanatory'.tr,
                              style: TextStyle(
                                fontSize: util.fontSize16,
                                fontFamily: AppFont.get(FontType.medium),
                                height: util.lineHeight19_2 / util.fontSize16,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          // onSelected('short');
                          onSelected(
                              StyleOption(name: 'Concise', icon: chatConcise));
                        },
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              chatConcise,
                              colorFilter: ColorFilter.mode(
                                Platform.isAndroid ? mainColor : iosMainColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Concise'.tr,
                              style: TextStyle(
                                fontSize: util.fontSize16,
                                fontFamily: AppFont.get(FontType.medium),
                                height: util.lineHeight19_2 / util.fontSize16,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
    }

    void showAvatarSelectionSheet(BuildContext context) {
      final int initialIndex = selectedAvatar == null
          ? 0
          : avatars.indexWhere((a) => a.title == selectedAvatar!.title);

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => AvatarBottomSheet(
          selectedIndex: initialIndex,
          onAvatarSelected: (AvatarOption avatar) {
            setState(() {
              selectedAvatar = avatar;
            });
            widget.avatar(selectedAvatar!.title.toLowerCase());
            saveChatPreference(
              selectedStyle?.name == 'Explanatory'
                  ? 'long'
                  : selectedStyle?.name == 'Concise'
                      ? 'short'
                      : '',
              avatar.title.toLowerCase(),
              selectedLanguage ?? 'English',
            );
            AuthService().updateChatFormat(
              format: selectedStyle?.name == 'Explanatory'
                  ? 'long'
                  : selectedStyle?.name == 'Concise'
                      ? 'short'
                      : '',
              avatar: avatar.title.toLowerCase(),
              chatLanguage: selectedLanguage ?? 'English',
            );
          },
        ),
      );
    }

    void showLanguageModal(BuildContext context, Function(String) onSelected) {
      final util = MyUtility(context);

      showGeneralDialog(
        barrierLabel: '',
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: util.responsiveWidth(0.6),
                height: util.responsiveHeight(0.1306),
                margin: EdgeInsets.only(
                    bottom: 60,
                    right: util.responsiveWidth(0.346),
                    left: util.width20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withValues(alpha: 0.17),
                      blurRadius: 23,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (customLanguage != null && customLanguage != 'English')
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                            onSelected(customLanguage!);
                            setState(() {
                              chatLanguage = customLanguage!;
                              selectedLanguage = customLanguage!;
                            });
                            await saveChatLanguage(customLanguage!);
                            await saveChatPreference(
                              selectedStyle?.name == 'Explanatory'
                                  ? 'long'
                                  : selectedStyle?.name == 'Concise'
                                      ? 'short'
                                      : '',
                              selectedAvatar?.title.toLowerCase() ?? '',
                              // customLanguage!,
                              selectedLanguage!,
                            );
                            AuthService().updateChatFormat(
                              format: selectedStyle?.name == 'Explanatory'
                                  ? 'long'
                                  : selectedStyle?.name == 'Concise'
                                      ? 'short'
                                      : '',
                              avatar: selectedAvatar?.title.toLowerCase() ?? '',
                              chatLanguage: selectedLanguage!,
                            );
                          },
                          child: Row(
                            spacing: util.width10,
                            children: [
                              Text(
                                customLanguage!,
                                style: TextStyle(
                                  fontSize: util.fontSize16,
                                  fontFamily: AppFont.get(FontType.medium),
                                  height: util.lineHeight19_2 / util.fontSize16,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          onSelected("English");
                          setState(() {
                            chatLanguage = "English";
                            selectedLanguage = "English";
                          });
                          await saveChatLanguage("English");
                          await saveChatPreference(
                            selectedStyle?.name == 'Explanatory'
                                ? 'long'
                                : selectedStyle?.name == 'Concise'
                                    ? 'short'
                                    : '',
                            selectedAvatar?.title.toLowerCase() ?? '',
                            "English",
                          );
                          AuthService().updateChatFormat(
                            format: selectedStyle?.name == 'Explanatory'
                                ? 'long'
                                : selectedStyle?.name == 'Concise'
                                    ? 'short'
                                    : '',
                            avatar: selectedAvatar?.title.toLowerCase() ?? '',
                            chatLanguage: "English",
                          );
                        },
                        child: Row(
                          spacing: util.width10,
                          children: [
                            Text(
                              'English',
                              style: TextStyle(
                                fontSize: util.fontSize16,
                                fontFamily: AppFont.get(FontType.medium),
                                height: util.lineHeight19_2 / util.fontSize16,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 15),
      color: Platform.isAndroid ? Color(0xffE3F8E1) : null,
      child: !_isRecording
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        // height: containerHeight,
                        width: util.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width30),
                          border: Border.all(
                              width: 1.36,
                              color: blackColor.withValues(alpha: 0.12)),
                          color: whiteColor,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: ValueKey(_isRecording),
                                enabled: widget.isInputDisabled ||
                                    messageMode == 'audio' ||
                                    messageMode == 'hybrid',
                                focusNode: widget.focusNode,
                                controller: widget.messageController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 2,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(
                                //     RegExp(r'[\x00-\x7F]'),
                                //   ),
                                // ],
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  height: util.lineHeight19_2 / util.fontSize16,
                                  color: blackColor,
                                ),
                                decoration: InputDecoration(
                                  hint: AnimatedHint(
                                    texts: Platform.isAndroid
                                        ? [
                                            'Tap the mic'.tr,
                                            'Start speaking in your own language'
                                                .tr,
                                          ]
                                        : [
                                            'Chat or record your thoughts...'.tr
                                          ],
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize15,
                                      height:
                                          util.lineHeight19_2 / util.fontSize15,
                                      color: blackColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  // hintText: 'Speak in your own language!',
                                  hintStyle: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize15,
                                      height:
                                          util.lineHeight19_2 / util.fontSize15,
                                      color: blackColor.withValues(alpha: 0.4)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: util.width20,
                                      top: util.height10,
                                      bottom: util.height10),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: !widget.isInputDisabled
                                  ? null
                                  : () {
                                      if (selectedStyle == null ||
                                          selectedStyle!.name.isEmpty) {
                                        if (selectedAvatar == null ||
                                            selectedAvatar!.title.isEmpty) {
                                          if (selectedLanguage == null ||
                                              selectedLanguage!.isEmpty) {
                                            showInfoSnackBarDual(
                                              context,
                                              "Choose your Style, Avatar and Language to begin your cosmic journey.",
                                            );
                                          } else {
                                            showInfoSnackBarDual(
                                              context,
                                              "Select a Style and Avatar to begin your cosmic journey.",
                                            );
                                          }
                                        } else {
                                          showInfoSnackBarDual(
                                            context,
                                            "Select a Style for your answer’s flow.",
                                          );
                                        }
                                        return;
                                      }

                                      if (selectedAvatar == null ||
                                          selectedAvatar!.title.isEmpty) {
                                        showInfoSnackBarDual(
                                          context,
                                          "Select an Avatar that reflects your spirit.",
                                        );
                                        return;
                                      }

                                      if (selectedLanguage == null ||
                                          selectedLanguage!.isEmpty) {
                                        showInfoSnackBarDual(
                                          context,
                                          "Select a Language for your answer’s flow.",
                                        );
                                        return;
                                      }

                                      final raw = widget.messageController.text;
                                      final msg = sanitizeMessage(raw);

                                      if (msg.isEmpty) {
                                        showInfoSnackBarDual(
                                          context,
                                          "Your message looks empty after removing hidden characters. Try typing or paste plain text.",
                                        );
                                        return;
                                      }
                                      if (msg.length > 300) {
                                        showInfoSnackBarDual(
                                          context,
                                          'Keep it short and cosmic — max 300 characters',
                                        );
                                        return;
                                      }
                                      widget.messageController.text = msg;
                                      print(
                                          '📤 Sending message with messageMode: $messageMode');
                                      widget.onMessageModeChanged(messageMode);
                                      widget.sendMessage();
                                    },
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: util.width20,
                                    vertical: util.width10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      widget.messageController.text.length > 300
                                          ? Colors.grey.shade400
                                          : (Platform.isAndroid
                                              ? mainColor
                                              : iosMainColor),
                                ),
                                child: SvgPicture.asset(
                                  send,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),

                    ///Mic
                    GestureDetector(
                      onTap: !widget.isInputDisabled
                          ? null
                          : () async {
                              if (_isRecording) {
                                await _stopRecording();
                              } else {
                                await _startRecording();
                              }
                            },
                      child: Container(
                        margin: EdgeInsets.only(right: 6),
                        padding: EdgeInsets.symmetric(
                            horizontal: util.width10, vertical: util.width10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color:
                                  Platform.isAndroid ? mainColor : iosMainColor,
                              width: 1.36),
                          color: _isRecording
                              ? (Platform.isAndroid ? mainColor : iosMainColor)
                                  .withValues(alpha: 0.2)
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          chatMicIcon,
                          colorFilter: ColorFilter.mode(
                            Platform.isAndroid ? mainColor : iosMainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: util.height10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showStyleModal(context, (StyleOption value) {
                            String selValue =
                                value.name == 'Explanatory' ? 'long' : 'short';
                            setState(() {
                              selectedStyle = value;
                            });
                            widget.onStyleSelected(selValue);
                            saveChatPreference(
                              selValue,
                              selectedAvatar?.title.toLowerCase() ?? '',
                              selectedLanguage ?? 'English',
                            );
                            AuthService().updateChatFormat(
                              format: selValue,
                              avatar: selectedAvatar?.title.toLowerCase() ?? '',
                              chatLanguage: selectedLanguage ?? 'English',
                            );
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 5),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                selectedStyle?.icon ?? chatStyle,
                                colorFilter: ColorFilter.mode(
                                  Platform.isAndroid ? mainColor : iosMainColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                selectedStyle?.name.tr ?? 'Style',
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize16,
                                    height: 1.0,
                                    color: blackColor.withValues(alpha: 0.6)
                                    // color: selectedStyle?.name != null ? mainColor : blackColor.withValues(alpha: 0.6)
                                    ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Transform.rotate(
                                angle: 270 * math.pi / 180,
                                child: SvgPicture.asset(dropDownArrow),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          showAvatarSelectionSheet(context);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 5),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                selectedAvatar?.imagePath ?? chatAvatar,
                                colorFilter: selectedAvatar?.imagePath == null
                                    ? ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn,
                                      )
                                    : null,
                                width: 18,
                                height: 18,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                selectedAvatar?.title.tr ?? 'Avatar',
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  height: 1.0,
                                  color: blackColor.withValues(alpha: 0.6),
                                  // color: selectedAvatar!.title.isNotEmpty ? mainColor : blackColor.withValues(alpha: 0.6)
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Transform.rotate(
                                angle: 270 * math.pi / 180,
                                child: SvgPicture.asset(dropDownArrow),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          showLanguageModal(context, (String lang) {
                            widget.selectedLanguage(lang.toLowerCase());
                            setState(() {
                              selectedLanguage = lang;
                            });
                            saveChatPreference(
                              selectedStyle?.name == 'Explanatory'
                                  ? 'long'
                                  : selectedStyle?.name == 'Concise'
                                      ? 'short'
                                      : '',
                              selectedAvatar?.title.toLowerCase() ?? '',
                              "English",
                            );
                            AuthService().updateChatFormat(
                              format: selectedStyle?.name == 'Explanatory'
                                  ? 'long'
                                  : selectedStyle?.name == 'Concise'
                                      ? 'short'
                                      : '',
                              avatar: selectedAvatar?.title.toLowerCase() ?? '',
                              chatLanguage: lang,
                            );
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 5),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                langIcon,
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  Platform.isAndroid ? mainColor : iosMainColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                (() {
                                  final sl = selectedLanguage ?? '';
                                  if (sl.isEmpty) return 'Language';
                                  return TextHelper.capitalizeFirstLetter(sl);
                                })(),
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  height: 1.0,
                                  color: blackColor.withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(width: 6),
                              Transform.rotate(
                                angle: 270 * math.pi / 180,
                                child: SvgPicture.asset(dropDownArrow),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: util.height20,
                  // height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : util.height20,
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          await _recorder.stop();

                          if (_tempFilePath != null) {
                            final file = File(_tempFilePath!);
                            if (await file.exists()) {
                              await file.delete();
                            }
                            _tempFilePath = null;
                          }

                          setState(() {
                            _isRecording = false;
                            _isConverting = false;
                          });
                        },
                        child: SvgPicture.asset(chatDeleteIcon)),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _formatTime(_remainingTime),
                      style: TextStyle(
                        fontSize: util.fontSize18,
                        fontFamily: "FontMedium",
                        color: blackColor.withValues(alpha: 0.4),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    _isConverting
                        ? Expanded(
                            child: SizedBox(
                              height: 80,
                              child: Center(
                                  child: Text(
                                'Got it, typing that up for you…'.tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.fontSize13,
                                    color: Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor),
                              )),
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                              // width: util.width / 1.75,
                              height: 80,
                              child: CustomPaint(
                                painter: WaveformBarsPainter(displayAmps,
                                    color: Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _stopRecording();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 6),
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color:
                                  Platform.isAndroid ? mainColor : iosMainColor,
                              width: 1.36),
                          color: Platform.isAndroid ? mainColor : iosMainColor,
                        ),
                        child: SvgPicture.asset(stopRecordChat),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: util.height10,
                ),
                Text(
                  'AI can understand all languages'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize16,
                      color: Platform.isAndroid ? mainColor : iosMainColor),
                ),
                SizedBox(
                  height: util.height10,
                  // height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : util.height20,
                ),
              ],
            ),
    );
  }
}
