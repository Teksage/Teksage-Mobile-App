import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:flutter/material.dart';

class LoginMethodTabs extends StatelessWidget {
  final LoginMethodTab active;
  final ValueChanged<LoginMethodTab> onChange;

  const LoginMethodTabs({
    super.key,
    required this.active,
    required this.onChange,
  });

  static const _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final isMobile = active == LoginMethodTab.mobile;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(util.width12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: _switchDuration,
                curve: Curves.easeInOutCubic,
                left: isMobile ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(util.width10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _TabLabel(
                    label: LoginConstants.tabMobile,
                    selected: isMobile,
                    onTap: () => onChange(LoginMethodTab.mobile),
                  ),
                  _TabLabel(
                    label: LoginConstants.tabEmail,
                    selected: !isMobile,
                    onTap: () => onChange(LoginMethodTab.email),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(util.width10),
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: util.width10),
            child: AnimatedDefaultTextStyle(
              duration: LoginMethodTabs._switchDuration,
              curve: Curves.easeInOut,
              style: TextStyle(
                fontFamily: AppFont.get(
                  selected ? FontType.semiBold : FontType.medium,
                ),
                fontSize: util.fontSize14,
                color: selected
                    ? const Color(0xFF171717)
                    : const Color(0xFF737373),
              ),
              child: Text(label, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
