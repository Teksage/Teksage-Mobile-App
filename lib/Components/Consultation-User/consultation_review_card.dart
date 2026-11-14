import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Consultation review — view after submit; Edit/Delete until admin approves.
class ConsultationReviewCard extends StatefulWidget {
  final int eventId;
  final double? rating;
  final String? feedback;
  final String? reviewStatus;
  final VoidCallback onUpdated;
  final String? title;
  final Future<bool> Function(Map<String, dynamic> body)? onSubmitReview;
  final Future<bool> Function()? onDeleteReview;

  const ConsultationReviewCard({
    super.key,
    required this.eventId,
    this.rating,
    this.feedback,
    this.reviewStatus,
    required this.onUpdated,
    this.title,
    this.onSubmitReview,
    this.onDeleteReview,
  });

  @override
  State<ConsultationReviewCard> createState() => _ConsultationReviewCardState();
}

class _ConsultationReviewCardState extends State<ConsultationReviewCard> {
  late int _stars;
  late TextEditingController _feedbackCtrl;
  bool _busy = false;
  late bool _editing;

  bool get _hasReview => (widget.rating ?? 0) > 0;
  bool get _isApproved => widget.reviewStatus == 'approved';
  bool get _isPending => widget.reviewStatus == 'pending';
  bool get _isRejected => widget.reviewStatus == 'rejected';

  @override
  void initState() {
    super.initState();
    _stars = (widget.rating ?? 0).round().clamp(0, 5);
    _feedbackCtrl = TextEditingController(text: widget.feedback ?? '');
    _editing = !_hasReview;
  }

  @override
  void didUpdateWidget(covariant ConsultationReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating ||
        oldWidget.feedback != widget.feedback ||
        oldWidget.reviewStatus != widget.reviewStatus) {
      _stars = (widget.rating ?? 0).round().clamp(0, 5);
      _feedbackCtrl.text = widget.feedback ?? '';
      _editing = !_hasReview;
    }
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_stars < 1) {
      Get.snackbar('Error'.tr, 'Please select a star rating.'.tr);
      return;
    }
    setState(() => _busy = true);
    final body = <String, dynamic>{
      'rating': _stars,
      if (_feedbackCtrl.text.trim().isNotEmpty)
        'feedback': _feedbackCtrl.text.trim(),
    };
    final ok = widget.onSubmitReview != null
        ? await widget.onSubmitReview!(body)
        : await AstroUserEventService().updateAstrologerEvent(
              widget.eventId,
              body,
            ) !=
            null;
    setState(() => _busy = false);
    if (ok) {
      Get.snackbar('Success'.tr, 'Review submitted for approval.'.tr);
      setState(() => _editing = false);
      widget.onUpdated();
    } else {
      Get.snackbar(
          'Error'.tr, 'Could not submit your review. Please try again.'.tr);
    }
  }

  Future<void> _delete() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete'.tr),
        content: Text('Delete your review?'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Delete'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    final ok = widget.onDeleteReview != null
        ? await widget.onDeleteReview!()
        : await AstroUserEventService().updateAstrologerEvent(
              widget.eventId,
              {'clear_review': true},
            ) !=
            null;
    setState(() => _busy = false);
    if (ok) {
      setState(() {
        _stars = 0;
        _feedbackCtrl.text = '';
        _editing = true;
      });
      widget.onUpdated();
    } else {
      Get.snackbar(
          'Error'.tr, 'Could not delete your review. Please try again.'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    if (_isApproved) {
      return _card(
        util,
        chip: _chip('Published'.tr, mainColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _starsRow(interactive: false),
            if ((widget.feedback ?? '').trim().isNotEmpty) ...[
              SizedBox(height: 8),
              Text(widget.feedback!.trim(),
                  style: TextStyle(fontSize: util.fontSize14)),
            ],
          ],
        ),
      );
    }

    if (_hasReview && !_editing) {
      return _card(
        util,
        chip: _isPending
            ? _chip('Pending'.tr, const Color(0xffFBC02D))
            : _isRejected
                ? _chip('Not published'.tr, Colors.grey)
                : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _starsRow(interactive: false),
            SizedBox(height: 6),
            Text(
              _isPending
                  ? 'Pending — you can still edit until approved.'.tr
                  : _isRejected
                      ? 'Edit and resubmit for approval.'.tr
                      : 'Reviews appear after admin approval.'.tr,
              style: TextStyle(
                fontSize: util.fontSize12,
                color: blackColor.withValues(alpha: 0.55),
              ),
            ),
            if ((widget.feedback ?? '').trim().isNotEmpty) ...[
              SizedBox(height: 8),
              Text(widget.feedback!.trim(),
                  style: TextStyle(fontSize: util.fontSize14)),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _busy ? null : _delete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                  ),
                  child: Text('Delete'.tr),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                            _stars =
                                (widget.rating ?? 0).round().clamp(0, 5);
                            _feedbackCtrl.text = widget.feedback ?? '';
                            _editing = true;
                          }),
                  child: Text('Edit'.tr),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return _card(
      util,
      chip: _isPending
          ? _chip('Pending'.tr, const Color(0xffFBC02D))
          : _isRejected
              ? _chip('Not published'.tr, Colors.grey)
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _starsRow(interactive: true),
          SizedBox(height: 8),
          TextField(
            controller: _feedbackCtrl,
            maxLines: 2,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: 'Write a short review (optional)'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_hasReview)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                            _stars =
                                (widget.rating ?? 0).round().clamp(0, 5);
                            _feedbackCtrl.text = widget.feedback ?? '';
                            _editing = false;
                          }),
                  child: Text('Cancel'.tr),
                ),
              ElevatedButton(
                onPressed: _busy ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: Text(
                  _busy
                      ? 'Submitting…'.tr
                      : (_hasReview ? 'Save changes'.tr : 'Submit review'.tr),
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: AppFont.get(FontType.semiBold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _starsRow({required bool interactive}) {
    return Row(
      children: List.generate(5, (i) {
        final n = i + 1;
        final icon = Icon(
          Icons.star,
          color: n <= _stars
              ? const Color(0xffFBC02D)
              : blackColor.withValues(alpha: 0.2),
          size: 28,
        );
        if (!interactive) return Padding(padding: EdgeInsets.only(right: 2), child: icon);
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () => setState(() => _stars = n),
          icon: icon,
        );
      }),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontFamily: AppFont.get(FontType.semiBold),
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _card(MyUtility util, {Widget? chip, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (widget.title ?? 'Rate your consultation').tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize15,
                    ),
                  ),
                ),
                if (chip != null) chip,
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(14), child: child),
        ],
      ),
    );
  }
}
