import 'package:flutter/material.dart';

class HeightReportingWidget extends StatefulWidget {
  final Widget child;
  final Function(double height) onSizeChange;

  const HeightReportingWidget({
    required this.child,
    required this.onSizeChange,
    super.key,
  });

  @override
  State<HeightReportingWidget> createState() => _HeightReportingWidgetState();
}

class _HeightReportingWidgetState extends State<HeightReportingWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());
  }

  void _reportSize() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      widget.onSizeChange(box.size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
