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

class AstrologerAskRequestDetailPage extends StatefulWidget {
  final int requestId;

  const AstrologerAskRequestDetailPage({super.key, required this.requestId});

  @override
  State<AstrologerAskRequestDetailPage> createState() =>
      _AstrologerAskRequestDetailPageState();
}

class _AstrologerAskRequestDetailPageState
    extends State<AstrologerAskRequestDetailPage> {
  final _service = AstrologerAskService();
  AskAstrologerRequest? _request;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final detail = await _service.fetchRequestDetail(widget.requestId);
    if (!mounted) return;
    if (detail == null) {
      setState(() {
        _loading = false;
        _error = 'Could not load request.'.tr;
      });
      return;
    }
    setState(() {
      _request = detail;
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
          'Consultation Details'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize18,
            color: blackColor,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(util.width20),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: mainColor,
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.all(util.width20),
                    children: [
                      Text(
                        'Review client details and submit text or voice answers.'
                            .tr,
                        style: TextStyle(
                          fontSize: util.fontSize14,
                          color: blackColor.withValues(alpha: 0.65),
                        ),
                      ),
                      SizedBox(height: util.height20),
                      AskAstrologerRequestCard(
                        request: _request!,
                        onAnswered: () {
                          _load();
                        },
                        isDetailPage: true,
                      ),
                    ],
                  ),
                ),
    );
  }
}
