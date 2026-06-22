import 'package:astro_prompt/Components/Astrologer/ask_astrologer_request_card.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/AskAstrologerService/astrologerAskService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AstrologerAskRequestsPage extends StatefulWidget {
  const AstrologerAskRequestsPage({super.key});

  @override
  State<AstrologerAskRequestsPage> createState() =>
      _AstrologerAskRequestsPageState();
}

class _AstrologerAskRequestsPageState extends State<AstrologerAskRequestsPage> {
  final _service = AstrologerAskService();
  List<AskAstrologerRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _service.fetchAssignedRequests();
    if (!mounted) return;
    setState(() {
      _requests = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
            colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Ask Requests'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize20,
            color: blackColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: mainColor,
        onRefresh: _load,
        child: _loading
            ? ListView(
                children: [
                  SizedBox(height: util.height50),
                  Center(child: CircularProgressIndicator(color: mainColor)),
                ],
              )
            : ListView(
                padding: EdgeInsets.all(util.width20),
                children: [
                  Text(
                    'Review client details and submit text or voice answers.'.tr,
                    style: TextStyle(
                      fontSize: util.fontSize14,
                      color: blackColor.withValues(alpha: 0.65),
                    ),
                  ),
                  SizedBox(height: util.height20),
                  if (_requests.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: util.height50),
                      child: Text(
                        'No Ask Astrologer requests yet.'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blackColor.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  else
                    ..._requests.map(
                      (req) => AskAstrologerRequestCard(
                        request: req,
                        onAnswered: _load,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
