import 'dart:async';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWidget extends StatefulWidget {
  final String htmlChart;
  const ChartWidget({super.key, required this.htmlChart});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late WebViewController webViewController;
  double webViewHeight = 300; // Default height

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'ResizeChannel',
        onMessageReceived: (JavaScriptMessage message) {
          double newHeight = double.tryParse(message.message) ?? 300;
          if (newHeight != webViewHeight) {
            setState(() {
              webViewHeight = newHeight;
            });
          }
        },
      );

    _loadHtml();
  }

  Future<void> _loadHtml() async {
    await webViewController.loadHtmlString(_wrapHtml(widget.htmlChart));
  }

  @override
  void didUpdateWidget(covariant ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlChart != widget.htmlChart) {
      _loadHtml();
    }
  }

  String _wrapHtml(String rawHtml) {
    return """
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <script>
        function resizeWebView() {
          var height = document.body.scrollHeight;
          ResizeChannel.postMessage(height.toString());
        }
        function observeSizeChanges() {
          new ResizeObserver(resizeWebView).observe(document.body);
        }
        window.onload = function() {
          resizeWebView();
          observeSizeChanges();
        };
      </script>
      <style>
        body { 
          margin: 0; 
          display:flex;
          padding: 5px; 
          background-color: white; 
          border-radius: 20px;
          // box-sizing: border-box;
        }
      </style>
    </head>
    <body>
      $rawHtml
    </body>
    </html>
    """;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Chart: ${widget.chartHtml}');
    // print('Width: ${util.responsiveWidth(0.8216)}');
    // print('Height: ${util.responsiveHeight(0.348)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 305,
      width: 339,
      // width: 338,
      // height: util.responsiveHeight(0.348),
      // width: util.responsiveWidth(0.8216),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: WebViewWidget(controller: webViewController),
    );
  }
}
