import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/Components/Chat/chatAppBar.dart';
import 'package:astro_prompt/Components/Chat/chatField.dart';
import 'package:astro_prompt/Components/Chat/iosChatBackground.dart';
import 'package:astro_prompt/Components/Chat/messageComponent.dart';
import 'package:astro_prompt/Components/Chat/chatMessageActions.dart';
import 'package:astro_prompt/Components/Common/typingIndicator.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/chat/chatBanner.dart';
import 'package:astro_prompt/Components/Chat/successDialog.dart';
import 'package:astro_prompt/Services/FeatureDiscovery/feature_discovery_prompt.dart';
import 'package:astro_prompt/Model/chat_message_model.dart';
import 'package:astro_prompt/Model/chat_preference_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page_IOS.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/ChatService/chatQueryService.dart';
import 'package:astro_prompt/Services/ChatService/socketConnection.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customShimmer.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen>
    with WidgetsBindingObserver {
  WebSocketService? webSocketService;
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  Set<int> selectedMessages = {};
  StringBuffer botBuffer = StringBuffer();
  bool isStreaming = false;
  String selectedStyle = '';
  String selectedAvatar = '';
  String selectedLanguage = '';
  String messageMode = '';
  bool premiumUser = false;
  String currency = '';
  List<String> relatedQueries = [];
  bool maintainHistory = false;
  bool loadChatHistory = false;
  bool showTypingIndicator = false;
  bool enableInput = true;
  String messageCountKey = 'message_count';
  int freeUserLimit = 5;
  int messageCount = 0;
  String userInitials = "AP";
  bool isRelatedLoading = false;
  ChatService maintainHistoryService = ChatService();
  Timer? responseTimer;
  bool isScreenVisible = true;
  StringBuffer deferredBotBuffer = StringBuffer();
  int? speakingIndex;
  bool showRelatedSection = true;
  bool atBottom = true;
  String planStatus = '';
  bool premiumLoaded = false;
  bool chatPrefLoaded = false;
  bool didInitialScroll = false;
  bool showInitialBanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInitialization();
      FeatureDiscoveryPrompt.maybeShow(context);
    });
  }

  void _startInitialization() {
    loadSavedChat();
    loadUserInitials();
    getProfileData();
  }

  void _onScroll() {
    final direction = scrollController.position.userScrollDirection;
    bool isAtBottom = scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 20;

    if (direction == ScrollDirection.forward) {
      if (showRelatedSection) {
        setState(() {
          showRelatedSection = false;
        });
      }
    } else if (direction == ScrollDirection.reverse) {
      if (isAtBottom && !showRelatedSection) {
        setState(() {
          showRelatedSection = true;
        });
      }
    }
    atBottom = isAtBottom;
  }

  void getPremiumUser() async {
    if (kDebugMode) {
      print('Fetching premium user status...');
    }
    final result = await getUserPremium();
    setState(() {
      premiumUser = result;
      premiumLoaded = true;
    });
    if (kDebugMode) {
      print('premiumUser: $premiumUser');
    }
  }

  void connectWebSocket() async {
    webSocketService = WebSocketService(
      url: ApiEndpoint.chatUrl,
      getToken: getAccessToken,
      refreshToken: APIRequest().refreshAccessToken,
      onData: handleSocketData,
      onDone: () {
        clearTimeout();
        if (!mounted) return;
        setState(() {
          isStreaming = false;
          enableInput = true;
          if (messages.isNotEmpty) {
            messages.last["isStreaming"] = false;
          }
          showTypingIndicator = false;
        });
      },
      onError: (error) {
        print("❌ WebSocket error: $error");
      },
    );

    await webSocketService?.connect();
    resumePendingBotResponseIfNeeded();
  }

  void handleSocketData(String data) {
    clearTimeout();
    if (!mounted) return;

    final trimmedData = data.trim();

    if (showTypingIndicator) {
      if (!mounted) return;
      setState(() {
        showTypingIndicator = false;
        enableInput = false;
      });
      scrollSlightly();
    }

    if (trimmedData == '[END]') {
      setState(() {
        isStreaming = false;
        enableInput = true;
        showTypingIndicator = false;
        if (messages.isNotEmpty) {
          messages.last["isStreaming"] = false;
        }
        for (int i = messages.length - 1; i >= 0; i--) {
          if (messages[i].containsKey("user") &&
              messages[i]["status"] == "pending") {
            messages[i]["status"] = "answered";
            break;
          }
        }
      });

      final lastUserMessage = messages
          .lastWhere((msg) => msg.containsKey("user"), orElse: () => {});
      if (lastUserMessage.isNotEmpty) {
        ChatService().getRelatedQueries(lastUserMessage["user"]).then((result) {
          if (mounted && result != null) {
            setState(() => relatedQueries = result.queries);
          }
        });
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) return;
        setState(() {
          if (messages.isNotEmpty &&
              messages.last.containsKey("audio") &&
              messages.last["audio"] == null) {
            messages.last.remove("audio");
          }
        });
      });

      scrollToBottom();
      return;
    }

    try {
      final decoded = jsonDecode(trimmedData);
      if (decoded is Map && decoded.containsKey("audio_base64")) {
        final audioBase64 = decoded["audio_base64"];
        if (audioBase64 != null && audioBase64.toString().isNotEmpty) {
          setState(() {
            if (messages.isNotEmpty && messages.last.containsKey("bot")) {
              messages.last = {
                ...messages.last,
                "audio": audioBase64,
                "isStreaming": false,
              };
            }
          });
        }
        return;
      }
    } catch (_) {}

    setState(() {
      if (!isStreaming) {
        isStreaming = true;
        botBuffer.clear();
        botBuffer.write(data);
        messages.add({
          "bot": botBuffer.toString(),
          "isStreaming": true,
          "audio": null,
          "shouldAnimate": true,
        });
      } else {
        botBuffer.write(data);
        messages.last = {
          ...messages.last,
          "bot": botBuffer.toString(),
          "isStreaming": true,
          "shouldAnimate": messages.last["shouldAnimate"] ?? true,
        };
      }
    });
  }

  void scrollSlightly() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !scrollController.hasClients) return;
      final currentPosition = scrollController.position.pixels;
      final maxScroll = scrollController.position.maxScrollExtent;
      final targetPosition = (currentPosition + 50).clamp(0.0, maxScroll);
      if (targetPosition > currentPosition) {
        print('One is called');
        scrollController.animateTo(
          targetPosition,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> resumePendingBotResponseIfNeeded() async {
    if (webSocketService?.isConnected != true) return;
    if (messages.isEmpty) return;

    for (int i = messages.length - 1; i >= 0; i--) {
      final msg = messages[i];
      if (msg.containsKey('user') &&
          (msg["status"] == "pending" || msg["status"] == "failed")) {
        final queryText = msg["user"];

        final avatar = selectedAvatar
            .replaceAll(RegExp(r'\bthe\b', caseSensitive: false), '')
            .trim();
        final messageToSend = {
          "query": queryText,
          "format": selectedStyle,
          "avator": avatar,
          "message_mode": "text",
          "chat_language": "english"
        };

        setState(() {
          messages[i]["status"] = "pending";
          showTypingIndicator = true;
          enableInput = false;
          isStreaming = false;
          botBuffer.clear();
        });

        webSocketService?.send(jsonEncode(messageToSend));

        responseTimer?.cancel();
        responseTimer = Timer(Duration(seconds: 30), () {
          if (isStreaming && messages[i]["status"] == "pending") {
            setState(() {
              showTypingIndicator = false;
              enableInput = true;
              messages[i]["status"] = "failed";
            });
            showInfoSnackBarDual(context, 'Timeout. Please retry.');
          }
        });

        scrollToBottom();
        return;
      }
    }
    if (kDebugMode) {
      print("✅ No pending/failed messages found.");
    }
  }

  Future<void> getProfileData() async {
    ProfileService profileService = ProfileService();
    try {
      UserProfile? profileData = await profileService.fetchUserProfile();

      if (profileData != null && profileData.subscription != null) {
        setState(() {
          planStatus = profileData.subscription?.planStatus ?? '';
        });
        if (kDebugMode) print('Plan Status: $planStatus');
        connectWebSocket();
        getPremiumUser();
      } else {
        if (kDebugMode) {
          print('Profile data or subscription is null');
        }
        connectWebSocket();
        getPremiumUser();
      }
    } on IncompleteProfileException {
      Get.to(() => ProfilePage(
            title: 'Profile Details',
            isProfileUpdated: false,
          ));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile Chat: $e');
      }
      connectWebSocket();
      getPremiumUser();
    }
  }

  void sendMessage() async {
    print('MessageCount: $messageCount');
    final bool isExpired = planStatus.trim().toLowerCase() == 'expired';
    final bool isPremiumActive = premiumUser && !isExpired;

    if (messageController.text.trim().isEmpty) {
      showInfoSnackBarDual(context, 'Kindly enter your question.');
      return;
    }

    if (isExpired && premiumUser) {
      showInfoSnackBarDual(
          context, 'Your subscription has expired. Subscribe to continue.');
      return;
    }

    if (!isPremiumActive) {
      if (messageCount >= freeUserLimit) {
        showInfoSnackBarDual(context,
            'You’ve reached your message limit. Subscribe to continue.');
        return;
      }
      setState(() {
        messageCount++;
      });
    }

    final queryText = messageController.text.trim();
    final avatar = selectedAvatar
        .replaceAll(RegExp(r'\bthe\b', caseSensitive: false), '')
        .trim();
    final messageToSend = Platform.isIOS
        ? {
            "query": queryText,
            "format": selectedStyle,
            "avator": avatar,
            "message_mode": messageMode,
            "chat_language": selectedLanguage,
            "device": "ios"
          }
        : {
            "query": queryText,
            "format": selectedStyle,
            "avator": avatar,
            "message_mode": messageMode,
            "chat_language": selectedLanguage,
          };
    if (kDebugMode) {
      print('Message Text: $messageToSend');
    }
    webSocketService?.send(jsonEncode(messageToSend));
    final bool wasShowingBanner = showInitialBanner;
    setState(() {
      showInitialBanner = false;
      showTypingIndicator = true;
      enableInput = false;
      messages.add({
        "user": queryText,
        "status": "pending",
        "shouldAnimate": true,
      });
      botBuffer.clear();
      isStreaming = false;
    });
    responseTimer?.cancel();
    responseTimer = Timer(Duration(seconds: 30), () {
      if (isStreaming) {
        setState(() {
          showTypingIndicator = false;
          enableInput = true;
          for (int i = messages.length - 1; i >= 0; i--) {
            if (messages[i].containsKey("user") &&
                messages[i]["status"] == "pending") {
              messages[i]["status"] = "failed";
              break;
            }
          }
        });
        showInfoSnackBarDual(context,
            'Response is taking longer than expected. Please check your network.');
      }
    });
    messageController.clear();

    if (wasShowingBanner) {
      // If banner was showing, give extra time for layout to settle after banner removal
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) ensureLastMessageVisible(animate: true);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ensureLastMessageVisible(animate: false);
      });
    }
  }

  void clearTimeout() {
    if (responseTimer != null) {
      responseTimer!.cancel();
      responseTimer = null;
    }
  }

  void toggleSelection(int index) {
    final message = messages[index];
    final isUserMessage = message.containsKey('bot');
    if (!isUserMessage) return;

    setState(() {
      if (selectedMessages.contains(index)) {
        selectedMessages.remove(index);
      } else {
        selectedMessages.add(index);
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> ensureLastMessageVisible({bool animate = true}) async {
    const int maxAttempts = 6;
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(Duration(milliseconds: attempt == 0 ? 50 : 100));
      if (!mounted) return;
      if (!scrollController.hasClients) continue;
      try {
        final maxScroll = scrollController.position.maxScrollExtent;
        if (maxScroll >= 0) {
          if (animate) {
            await scrollController.animateTo(
              maxScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            scrollController.jumpTo(maxScroll);
          }
          return;
        }
      } catch (_) {}
    }
    if (mounted && scrollController.hasClients) {
      try {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } catch (_) {}
    }
  }

  Future<void> performInitialScroll() async {
    if (didInitialScroll) return;

    const int maxAttempts = 6;
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(Duration(milliseconds: attempt == 0 ? 50 : 100));
      if (!mounted) return;
      if (!scrollController.hasClients) continue;
      try {
        final maxScroll = scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          scrollController.jumpTo(maxScroll);
          didInitialScroll = true;
          return;
        }
      } catch (_) {}
    }

    if (mounted && scrollController.hasClients) {
      try {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } catch (_) {}
    }
    didInitialScroll = true;
  }

  void showDownloadSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DownloadSuccessDialog(title: 'Chat Downloaded');
      },
    );
  }

  void dismissKeyboard() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  Future<void> loadSavedChat() async {
    try {
      final ChatPreference? chatPreference =
          await ChatService().getMaintainHistory();
      if (chatPreference != null) {
        if (!chatPreference.isPrimeCustomer) {
          setState(() {
            messageCount = chatPreference.chatCountLast7Days;
          });
          if (kDebugMode) {
            print(
                'Chat count in last 7 days: ${chatPreference.chatCountLast7Days}');
          }
        }
        final List<ChatMessageModel> chatMessages =
            await ChatService.fetchChatHistory(
                maintainHistory: chatPreference.maintainHistory);
        if (chatMessages.isNotEmpty) {
          setState(() {
            showInitialBanner = false;
            messages.clear();
            for (final msg in chatMessages) {
              messages.add({"user": msg.userQuestion, "shouldAnimate": false});
              messages.add({"bot": msg.apiResponse, "shouldAnimate": false});
            }
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (scrollController.hasClients) {
              try {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
                didInitialScroll = true;
              } catch (_) {
                performInitialScroll();
              }
            } else {
              performInitialScroll();
            }
          });
        } else {
          if (kDebugMode) {
            print('There is no message to Show');
          }
          setState(() {
            showInitialBanner = true;
            messageCount = chatPreference.chatCountLast7Days;
          });
        }
      }
      setState(() {
        chatPrefLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading chat history: $e');
      }
    }
  }

  void loadUserInitials() async {
    String firstName = await getUserName();
    String lastName = await getLastName();
    setState(() {
      userInitials =
          '${firstName.trim()[0]}${lastName.trim()[0]}'.toUpperCase();
    });
  }

  void retryMessage(int index) {
    final failedText = messages[index]["user"];

    setState(() {
      messages[index]["status"] = "pending";
      showTypingIndicator = true;
      enableInput = false;
      botBuffer.clear();
      isStreaming = false;
    });

    final avatar = selectedAvatar
        .replaceAll(RegExp(r'\bthe\b', caseSensitive: false), '')
        .trim();
    final messageToSend = {
      "query": failedText,
      "format": selectedStyle,
      "avator": avatar,
    };

    webSocketService?.send(jsonEncode(messageToSend));

    responseTimer?.cancel();
    responseTimer = Timer(Duration(seconds: 30), () {
      if (isStreaming && messages[index]["status"] == "pending") {
        setState(() {
          showTypingIndicator = false;
          enableInput = true;
          messages[index]["status"] = "failed";
        });
        showInfoSnackBarDual(context, 'Retry response timed out.');
      }
    });

    scrollToBottom();
  }

  void savePartialBotMessage() {
    if (isStreaming && botBuffer.isNotEmpty) {
      if (messages.isNotEmpty && messages.last.containsKey("bot")) {
        messages.last["bot"] = botBuffer.toString();
      } else {
        messages.add({
          "bot": botBuffer.toString(),
        });
      }
      messages.last["isStreaming"] = false;
      isStreaming = false;
      showTypingIndicator = false;
      enableInput = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      isScreenVisible = true;

      if (deferredBotBuffer.isNotEmpty) {
        if (kDebugMode) {
          print("📥 Applying deferred bot data");
        }
        setState(() {
          if (!isStreaming) {
            isStreaming = true;
            botBuffer.clear();
            botBuffer.write(deferredBotBuffer.toString());
            messages.add({
              "bot": botBuffer.toString(),
              "isStreaming": true,
              "audio": null,
            });
          } else {
            botBuffer.write(deferredBotBuffer.toString());
            messages.last = {"bot": botBuffer.toString(), "isStreaming": true};
          }
          deferredBotBuffer.clear();
        });
      }
    } else {
      isScreenVisible = false;
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    scrollToBottom();
  }

  @override
  void dispose() {
    webSocketService?.disconnect();
    messageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    savePartialBotMessage();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final bool isExpired = planStatus.trim().toLowerCase() == 'expired';
    final bool isPremiumActive = premiumUser && !isExpired;
    final bool canUseChatInput =
        !isExpired && (isPremiumActive || messageCount < freeUserLimit);
    final bool dataReady = premiumLoaded && chatPrefLoaded;
    final String subscribeMessage = isExpired
        ? 'Your subscription has expired.\nSubscribe to continue.'
        : 'You\u2019ve reached your message limit. Subscribe to continue.';

    final double statusBar = MediaQuery.of(context).padding.top;
    const double headerBody = 100;
    final double headerHeight = statusBar + headerBody;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && Platform.isAndroid) {
          Future.microtask(() async {
            Get.back();
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: selectedMessages.isNotEmpty
            ? AnimatedSlide(
                offset:
                    selectedMessages.isNotEmpty ? Offset(0, 0) : Offset(0, 1),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  height: util.responsiveHeight(0.1232),
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  decoration: BoxDecoration(
                    color: mainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${selectedMessages.length} Selected",
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize18,
                          height: util.lineHeight21_6 / util.fontSize18,
                          color: whiteColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final bool isExpiredTap =
                              planStatus.trim().toLowerCase() == 'expired';
                          final bool isPremiumActiveTap =
                              premiumUser && !isExpiredTap;
                          if (isPremiumActiveTap) {
                            final List<String> selectedBotMessages = [];

                            for (final index in selectedMessages) {
                              final msg = messages[index];
                              if (msg.containsKey('bot')) {
                                selectedBotMessages.add(msg['bot']);
                              } else {
                                if (kDebugMode) {
                                  print(
                                      "⚠️ Message at index $index does not contain 'bot' key: $msg");
                                }
                              }
                            }
                            try {
                              CustomLoader.show(context,
                                  loaderColor: panchangHeading);
                              await ChatService()
                                  .downloadSpecificChat(selectedBotMessages);
                              CustomLoader.hide();
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return DownloadSuccessDialog(
                                    title: 'Chat Downloaded',
                                  );
                                },
                              );
                              selectedMessages.clear();
                              setState(() {});
                            } catch (e) {
                              CustomLoader.hide();
                              showErrorSnackBar(context,
                                  "Download failed. Please try again.");
                            }
                          } else {
                            if (currency.isNotEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(128),
                                builder: (context) => SubscribePromptDialog(
                                  currency: currency,
                                  reDirectHome: true,
                                ),
                              );
                              return;
                            }

                            String tempCurrency = currency;

                            await CurrencyHelper.fetchCurrencyIfNeeded(
                              context: context,
                              currentCurrency: tempCurrency,
                              onCurrencyFetched: (fetchedCurrency) {
                                tempCurrency = fetchedCurrency;
                                currency = fetchedCurrency;
                              },
                            );

                            if (tempCurrency.isNotEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(128),
                                builder: (context) => SubscribePromptDialog(
                                  currency: tempCurrency,
                                  reDirectHome: true,
                                ),
                              );
                            } else {
                              showErrorSnackBar(
                                context,
                                'Please enable location permission to access this feature.',
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: util.width10, horizontal: util.width12),
                          decoration: BoxDecoration(
                            color: whiteColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                download,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              SizedBox(width: util.responsiveWidth(0.016)),
                              Text(
                                "Download",
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize16,
                                  height: util.lineHeight19_2 / util.fontSize16,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: GestureDetector(
          onTap: dismissKeyboard,
          child: Stack(
            children: [
              if (Platform.isIOS) const IosChatTopBackground(),
              if (Platform.isIOS) const IosChatBottomBackground(),
              Container(
                decoration: Platform.isAndroid
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            whiteColor,
                            whiteColor,
                            Color(0xffE3F8E1),
                            Color(0xffE3F8E1)
                          ],
                          stops: [0.0, 0.95, 0.95, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        image: DecorationImage(
                          image: AssetImage(chatBg),
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                child: Column(
                  children: [
                    if (Platform.isAndroid)
                      if (selectedMessages.isEmpty)
                        Column(
                          children: [
                            ChatAppBarWithDownload(
                              maintainHistory: maintainHistory,
                              premiumUser: premiumUser,
                              msgCount: messages.length,
                              onChatHistorySelected: (selection) async {
                                if (kDebugMode) {
                                  print('Selection: $selection');
                                }
                                if (selection == '1d') {
                                  await maintainHistoryService
                                      .updateMaintainHistory(
                                          maintainHistory: true);
                                } else if (selection == '1h') {
                                  await maintainHistoryService
                                      .updateMaintainHistory(
                                          maintainHistory: false);
                                }
                              },
                            ),
                            ChatBanner(
                              fromChat: true,
                            ),
                          ],
                        )
                      else
                        CharAppBarWithCancel(
                          onCancel: () {
                            setState(() {
                              selectedMessages.clear();
                            });
                          },
                        ),

                    showInitialBanner
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: util.height20,
                                horizontal: util.width20),
                            padding: EdgeInsets.only(
                                top: isKeyboardVisible
                                    ? (Platform.isIOS
                                        ? headerHeight + util.height50
                                        : util.height50)
                                    : (Platform.isIOS
                                        ? headerHeight + (util.height / 4)
                                        : util.height / 2.75)),
                            width: util.width,
                            child: Text(
                                'Jyotish voice guide for all your needs. Start you conversation today'
                                    .tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "FontMedium",
                                    fontSize: util.fontSize18,
                                    color: blackColor.withValues(alpha: 0.5))))
                        : SizedBox.shrink(),

                    ///Chat Messages
                    Flexible(
                      flex: 2,
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(
                          left: util.width20,
                          right: util.width20,
                          top: Platform.isIOS ? headerHeight : 0,
                        ),
                        itemCount:
                            messages.length + (showTypingIndicator ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length && showTypingIndicator) {
                            return TypingIndicator();
                          }
                          String sender = messages[index].keys.first;
                          String message = messages[index][sender]!.toString();
                          bool isSelected = selectedMessages.contains(index);
                          bool isStreaming =
                              messages[index]["isStreaming"] == true;
                          final status = messages[index]["status"];
                          final isFailedUserMessage = sender == "user" &&
                              status != null &&
                              status == "failed";
                          final bool isBot = sender == "bot";
                          final bool shouldAnimate =
                              messages[index]["shouldAnimate"] == true;

                          return GestureDetector(
                            onTap: () {
                              if (selectedMessages.isNotEmpty) {
                                toggleSelection(index);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: sender == "user"
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: sender == "user"
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      if (selectedMessages.isNotEmpty && isBot)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: util.width8),
                                          child: SvgPicture.asset(
                                            isSelected
                                                ? selectCheckBox
                                                : unSelectCheckBox,
                                          ),
                                        ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            sender == "user"
                                                ? (shouldAnimate
                                                    ? FadeInRight(
                                                        config:
                                                            BaseAnimationConfig(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          child:
                                                              MessageComponent(
                                                            text: message,
                                                            sender: sender,
                                                            profilePic:
                                                                userInitials,
                                                            audio: messages[
                                                                        index]
                                                                    .containsKey(
                                                                        "audio")
                                                                ? messages[
                                                                        index]
                                                                    ["audio"]
                                                                : null,
                                                          ),
                                                        ),
                                                      )
                                                    : MessageComponent(
                                                        text: message,
                                                        sender: sender,
                                                        profilePic:
                                                            userInitials,
                                                        audio: messages[index]
                                                                .containsKey(
                                                                    "audio")
                                                            ? messages[index]
                                                                ["audio"]
                                                            : null,
                                                      ))
                                                : (isStreaming
                                                    ? MessageComponent(
                                                        text: message,
                                                        sender: sender,
                                                        audio: messages[index]
                                                                .containsKey(
                                                                    "audio")
                                                            ? messages[index]
                                                                ["audio"]
                                                            : null,
                                                        messageMode:
                                                            messageMode,
                                                      )
                                                    : (shouldAnimate
                                                        ? FadeInLeft(
                                                            config:
                                                                BaseAnimationConfig(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              child:
                                                                  MessageComponent(
                                                                text: message,
                                                                sender: sender,
                                                                audio: messages[
                                                                            index]
                                                                        .containsKey(
                                                                            "audio")
                                                                    ? messages[
                                                                            index]
                                                                        [
                                                                        "audio"]
                                                                    : null,
                                                                messageMode:
                                                                    messageMode,
                                                              ),
                                                            ),
                                                          )
                                                        : MessageComponent(
                                                            text: message,
                                                            sender: sender,
                                                            audio: messages[
                                                                        index]
                                                                    .containsKey(
                                                                        "audio")
                                                                ? messages[
                                                                        index]
                                                                    ["audio"]
                                                                : null,
                                                            messageMode:
                                                                messageMode,
                                                          ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isFailedUserMessage)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 4, right: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "No response.".tr,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                        GestureDetector(
                                          onTap: () => retryMessage(index),
                                          child: Row(
                                            children: [
                                              Icon(Icons.refresh,
                                                  size: 16, color: Colors.blue),
                                              SizedBox(width: 4),
                                              Text(
                                                "Retry".tr,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (isBot &&
                                    !isStreaming &&
                                    selectedMessages.isEmpty &&
                                    index > 0 &&
                                    messages[index - 1].containsKey('user'))
                                  ChatMessageActions(
                                    userQuestion: messages[index - 1]['user']
                                        .toString(),
                                    aiResponse: message,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    ///Related Questions
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: child,
                      ),
                      child: showRelatedSection &&
                              selectedMessages.isEmpty &&
                              (isRelatedLoading ||
                                  (relatedQueries.isNotEmpty &&
                                      (isPremiumActive ||
                                          messageCount < freeUserLimit)))
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text('Related questions'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        color:
                                            blackColor.withValues(alpha: 0.6),
                                      )),
                                  SizedBox(height: util.height10),
                                  if (isRelatedLoading)
                                    Container(
                                      width: util.width,
                                      margin: EdgeInsets.only(
                                          right: util.width20,
                                          left: util.width20,
                                          bottom: util.height10),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: Column(
                                        children: [
                                          CustomShimmer(
                                            width: util.width,
                                            height: 40,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomShimmer(
                                            width: util.width,
                                            height: 40,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    ...relatedQueries.map((query) =>
                                        GestureDetector(
                                          onTap: isStreaming
                                              ? null
                                              : () {
                                                  setState(() {
                                                    messageController.text =
                                                        query;
                                                    messageController
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                          offset: query.length),
                                                    );
                                                  });
                                                },
                                          child: Container(
                                            width: util.width,
                                            margin: EdgeInsets.only(
                                                right: util.width20,
                                                left: util.width20,
                                                bottom: util.height10),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Platform.isAndroid
                                                      ? mainColor
                                                      : iosMainColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Text(
                                                toBeginningOfSentenceCase(
                                                        query) ??
                                                    '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: util.fontSize14,
                                                    color: blackColor)),
                                          ),
                                        )),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey("empty")),
                    ),

                    ///ChatTextArea
                    selectedMessages.isEmpty
                        ? (!dataReady
                            ? SizedBox.shrink()
                            : (canUseChatInput)
                                ? SafeArea(
                                    top: false,
                                    bottom: Platform.isAndroid ? true : false,
                                    child: ChatInputField(
                                      isPremium: premiumUser,
                                      messageController: messageController,
                                      focusNode: focusNode,
                                      sendMessage: sendMessage,
                                      isInputDisabled: enableInput,
                                      onMessageModeChanged: (mode) {
                                        setState(() {
                                          messageMode = mode;
                                        });
                                      },
                                      onStyleSelected: (style) {
                                        setState(() {
                                          selectedStyle = style;
                                        });
                                      },
                                      selectedLanguage: (language) {
                                        setState(() {
                                          selectedLanguage = language;
                                        });
                                      },
                                      avatar: (avatar) {
                                        setState(() {
                                          selectedAvatar = avatar;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    width: util.width,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Platform.isAndroid
                                        ? Color(0xffE3F8E1)
                                        : Colors.transparent,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: util.height20,
                                        ),
                                        Text(
                                          subscribeMessage.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'FontSemiBold',
                                              fontSize: util.fontSize16,
                                              color: errorColor,
                                              height: 1.3),
                                        ),
                                        SizedBox(
                                          height: util.height10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (Platform.isAndroid) {
                                              if (currency.isNotEmpty) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierColor: Colors.black
                                                      .withAlpha(128),
                                                  builder: (context) =>
                                                      SubscribePromptDialog(
                                                    currency: currency,
                                                    reDirectHome: true,
                                                  ),
                                                );
                                                return;
                                              }

                                              String tempCurrency = currency;
                                              await CurrencyHelper
                                                  .fetchCurrencyIfNeeded(
                                                context: context,
                                                currentCurrency: tempCurrency,
                                                onCurrencyFetched:
                                                    (fetchedCurrency) {
                                                  tempCurrency =
                                                      fetchedCurrency;
                                                  currency = fetchedCurrency;
                                                },
                                              );

                                              if (tempCurrency.isNotEmpty) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierColor: Colors.black
                                                      .withAlpha(128),
                                                  builder: (context) =>
                                                      SubscribePromptDialog(
                                                    currency: tempCurrency,
                                                    reDirectHome: true,
                                                  ),
                                                );
                                              } else {
                                                showErrorSnackBar(
                                                  context,
                                                  'Please enable location permission to access this feature.',
                                                );
                                              }
                                            } else {
                                              Get.to(() =>
                                                  SubscriptionDetailsPageIos());
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: util.width20),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            width: MyUtility(context).width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: whiteColor),
                                            child: Text(
                                              'Subscribe Now'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: AppFont.get(
                                                      FontType.semiBold),
                                                  fontSize: MyUtility(context)
                                                      .fontSize18,
                                                  color: Platform.isAndroid
                                                      ? mainColor
                                                      : iosMainColor,
                                                  height: 1.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom >
                                                  0
                                              ? 0
                                              : util.height30,
                                        ),
                                      ],
                                    ),
                                  ))
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Platform.isIOS
                  ? Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: IosAppBar(
                        height: headerHeight,
                        statusBar: statusBar,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
