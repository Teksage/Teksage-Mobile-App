import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Screens/Astrologer/astrologerAskRequestDetailPage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAstrologerRequestListCard extends StatelessWidget {
  final AskAstrologerRequest request;
  final VoidCallback? onReturned;

  const AskAstrologerRequestListCard({
    super.key,
    required this.request,
    this.onReturned,
  });

  String get _statusLabel {
    if (request.status == 'assigned') return 'Awaiting answer'.tr;
    if (request.status == 'answered') return 'Answered'.tr;
    return request.status;
  }

  String get _actionLabel => request.status == 'answered'
      ? 'View Details'.tr
      : 'View & Answer'.tr;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final name = (request.customerName ?? '').trim();
    final initials = _initials(name);

    return Padding(
      padding: EdgeInsets.only(bottom: util.height20),
      child: Material(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Get.to(
              () => AstrologerAskRequestDetailPage(requestId: request.id),
            );
            onReturned?.call();
          },
          child: Container(
            padding: EdgeInsets.all(util.width20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: blackColor.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor.withValues(alpha: 0.12),
                        border: Border.all(color: mainColor, width: 2),
                      ),
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          color: mainColor,
                          fontSize: util.fontSize14,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isEmpty ? 'Client'.tr : name,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Request #${request.id}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: blackColor.withValues(alpha: 0.45),
                                  fontFamily: AppFont.get(FontType.semiBold),
                                ),
                              ),
                              Text(
                                _statusLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: request.status == 'answered'
                                      ? mainColor
                                      : Colors.amber.shade800,
                                  fontFamily: AppFont.get(FontType.semiBold),
                                ),
                              ),
                              if (request.previousQaCount > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Returning'.tr,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: mainColor,
                                      fontFamily: AppFont.get(FontType.semiBold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: request.status == 'answered'
                            ? whiteColor
                            : mainColor,
                        borderRadius: BorderRadius.circular(20),
                        border: request.status == 'answered'
                            ? Border.all(
                                color: mainColor.withValues(alpha: 0.35))
                            : null,
                      ),
                      child: Text(
                        _actionLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: AppFont.get(FontType.semiBold),
                          color: request.status == 'answered'
                              ? mainColor
                              : whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  request.userQuestion,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: util.fontSize14,
                    color: blackColor.withValues(alpha: 0.8),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
