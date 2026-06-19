import 'dart:io';
import 'dart:ui';
import 'package:astro_prompt/Components/Chat/successDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:astro_prompt/Services/ChatService/chatQueryService.dart';
import 'package:astro_prompt/Services/HoroscopeService/fileStorageService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:astro_prompt/config/Helper/appFont.dart';

class ChatAppBarWithDownload extends StatefulWidget {
  final bool premiumUser;
  final int msgCount;
  final bool maintainHistory;
  final Function(String)? onChatHistorySelected;
  const ChatAppBarWithDownload(
      {super.key,
      required this.premiumUser,
      required this.msgCount,
      this.onChatHistorySelected,
      required this.maintainHistory});

  @override
  State<ChatAppBarWithDownload> createState() => _ChatAppBarWithDownloadState();
}

class _ChatAppBarWithDownloadState extends State<ChatAppBarWithDownload> {
  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    String currency = '';
    bool _isSending = false;

    Future<void> _handleSendMail() async {
      if (_isSending) return;
      _isSending = true;

      final currentContext = context;

      try {
        await Future.delayed(const Duration(milliseconds: 100));
        Get.back(); // Close first
        await Future.delayed(const Duration(milliseconds: 200));
        CustomLoader.show(currentContext, loaderColor: panchangHeading);
        final chatPdf = await ChatService().sendMail(widget.maintainHistory);
        if (!mounted) return;
        CustomLoader.hide();
        if (chatPdf['message'] == 'mail shared successfully') {
          showDialog(
            context: currentContext,
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.5),
            builder: (context) =>
                DownloadSuccessDialog(title: 'Mail Sent Successfully'),
          );
        } else {
          showErrorSnackBar(
              currentContext, 'We couldn’t mail your chat. Please try again.');
        }
      } catch (e) {
        CustomLoader.hide();
        if (mounted) {
          showErrorSnackBar(currentContext,
              'Something went wrong while sending the mail. Please try again.');
        }
      } finally {
        _isSending = false;
      }
    }

    Future<void> handleDownload() async {
      try {
        CustomLoader.show(context, loaderColor: panchangHeading);

        final chatPdfBytes = await ChatService().downloadChat();
        CustomLoader.hide();

        if (chatPdfBytes != null) {
          final fileName = 'AstroPromptChat';
          final filePath =
              await FileStorage.savePdfToDownloads(chatPdfBytes, fileName);
          final savedFileName = p.basename(filePath);

          if (context.mounted) {
            Future.microtask(() {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.white.withValues(alpha: 0.5),
                builder: (ctx) => DownloadSuccessDialog(
                  title: 'Chat downloaded Successfully',
                  file: savedFileName,
                ),
              );
            });
          }

          print('📁 Chat PDF path: $savedFileName');
        } else {
          if (context.mounted) {
            showErrorSnackBar(
                context, 'We couldn’t fetch your chat. Please try again.');
          }
        }
      } catch (e) {
        CustomLoader.hide();
        print("❌ Download error: $e");
        showErrorSnackBar(context, "Download failed. Please try again.");
      }
    }

    void showDropdownModal(BuildContext context) {
      final util = MyUtility(context);

      showGeneralDialog(
        barrierLabel: '',
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: util.responsiveWidth(0.6),
                height: util.responsiveHeight(0.1306),
                margin: EdgeInsets.only(
                    top: util.responsiveHeight(0.1195),
                    left: util.responsiveWidth(0.346),
                    right: util.width20),
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
                        onTap: () async {
                          if (!widget.premiumUser) {
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
                          } else if (widget.msgCount != 0) {
                            handleDownload();
                          } else {
                            showInfoSnackBarDual(context,
                                "Your astrological insights haven’t begun. Start a chat to unlock the stars!");
                            Get.back();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            spacing: util.width10,
                            children: [
                              SvgPicture.asset(download),
                              Text(
                                'Download Chat',
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
                      ),
                      GestureDetector(
                        onTap: () async {
                          print('Premium: ${widget.premiumUser}');
                          if (!widget.premiumUser) {
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
                          } else if (widget.msgCount != 0) {
                            _handleSendMail();
                          } else {
                            showInfoSnackBarDual(context,
                                "Your astrological insights haven’t begun. Start a chat to unlock the stars!");
                            Get.back();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            spacing: util.width10,
                            children: [
                              SvgPicture.asset(
                                downloadMail,
                                width: util.responsiveWidth(0.064),
                                height: util.responsiveHeight(0.0295),
                              ),
                              Text(
                                'Send to Mail',
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
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
    }

    return Column(
      children: [
        Container(color: mainColor, height: util.height30),
        Container(
          color: mainColor,
          width: util.width,
          height: util.responsiveHeight(0.121),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: util.width10),
                child: Platform.isIOS
                    ? Row(
                        children: [
                          SizedBox(
                            width: MyUtility(context).width / 8,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                PlatformTextConfig.chatTitle.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize20,
                                  height: util.lineHeight24 / util.fontSize20,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              profile,
                              colorFilter: const ColorFilter.mode(
                                whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () async {
                              Get.to(() => SettingsPage());
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // Back Button
                          IconButton(
                            icon: SvgPicture.asset(
                              appBackButton,
                              width: util.width20,
                              height: util.height20,
                            ),
                            onPressed: () async {
                              // if (widget.msgCount == 0) {
                              Get.back();
                              // } else {
                              //   final result = await showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     barrierColor: blackColor.withValues(alpha: 0.5),
                              //     builder: (context) => ChatHistoryDialog(),
                              //   );
                              //
                              //   if (result != null && widget.onChatHistorySelected != null) {
                              //     widget.onChatHistorySelected!(result);
                              //     Get.to(() => BottomNavigationScreen());
                              //   }
                              // }
                            },
                          ),
                          SizedBox(
                            width: MyUtility(context).width / 5,
                          ),
                          // Title
                          // Center(
                          //   child:
                          Text(
                            'ChatTitle'.tr,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize20,
                              height: util.lineHeight24 / util.fontSize20,
                              color: whiteColor,
                            ),
                          ),
                          // ),
                          // Action Button
                          // IconButton(
                          //   icon: SvgPicture.asset(actionIcon),
                          //   onPressed: () => showDropdownModal(context),
                          // ),
                        ],
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: util.width10,
                    vertical: util.responsiveWidth(0.016)),
                decoration: BoxDecoration(
                  color: whiteColor.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Jyotish voice guide for all your needs'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: util.fontSize13,
                        fontFamily: AppFont.get(FontType.semiBold),
                        height: util.lineHeight15_6 / util.fontSize13,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CharAppBarWithCancel extends StatelessWidget {
  final VoidCallback onCancel;
  const CharAppBarWithCancel({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Height: ${util.responsiveHeight(0.13)}');

    return Container(
      color: mainColor,
      width: util.width,
      height: util.responsiveHeight(0.1355),
      child: Stack(
        children: [
          Positioned(
            bottom: util.height20,
            child: Container(
              width: util.width,
              padding: EdgeInsets.symmetric(horizontal: util.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PlatformTextConfig.chatTitle,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize20,
                      height: util.lineHeight24 / util.fontSize20,
                      color: whiteColor,
                    ),
                  ),
                  GestureDetector(
                      onTap: onCancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize18,
                            height: util.lineHeight21_6 / util.fontSize18,
                            color: whiteColor),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IosAppBar extends StatefulWidget {
  final double height;
  final double statusBar;

  const IosAppBar({
    super.key,
    required this.height,
    required this.statusBar,
  });

  @override
  State<IosAppBar> createState() => _IosAppBarState();
}

class _IosAppBarState extends State<IosAppBar> {
  String userName = '';

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> fetchUserName() async {
    try {
      String name = await getUserName();
      setState(() {
        userName = name;
      });
    } catch (e) {
      if (kDebugMode) print('Error in fetchUserName: $e');
    }
    print('Fetched userName: $userName');
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              iosAppBarBg,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: widget.statusBar + 10,
              left: util.width50,
              right: 10,
              bottom: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          _getGreeting(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.regular),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            letterSpacing: -0.48,
                            color: blackColor.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName.isNotEmpty
                              ? userName[0].toUpperCase() +
                                  userName.substring(1)
                              : userName,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize24,
                            height: 1.0,
                            letterSpacing: -0.48,
                            color: Color(0xff002F55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    iosProfile,
                  ),
                  onPressed: () async {
                    Get.to(() => const SettingsPage());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
