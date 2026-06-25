import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';

class AnimatedHint extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;

  const AnimatedHint({super.key, required this.texts, required this.style});

  @override
  State<AnimatedHint> createState() => _AnimatedHintState();
}

class _AnimatedHintState extends State<AnimatedHint> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Rotate every 2 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() {
        currentIndex = (currentIndex + 1) % widget.texts.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return SizedBox(
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Container(
          key: ValueKey(widget.texts[currentIndex]),
          alignment: Alignment.topLeft,
          height: util.lineHeight19_2 * 2,
          child: Text(
            widget.texts[currentIndex],
            style: widget.style,
            textAlign: TextAlign.left,
            maxLines: 2, // safety
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

}

