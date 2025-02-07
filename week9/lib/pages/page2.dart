import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse("https://flutter.dev"))
      ..loadFlutterAsset('assets/web/map.html')
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Map Demo v1.0"),
      ),
      body: Stack(children: [
        WebViewWidget(controller: controller),
        if (loadingPercentage < 100)
          Column(
            children: [
              Text("Loading: $loadingPercentage %"),
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              )
            ],
          )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.runJavaScript('alert("Hello Html")');
        },
      ),
    );
  }
}
