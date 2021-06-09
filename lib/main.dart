import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Poolsuite(),
    );
  }
}

class Poolsuite extends StatefulWidget {
  Poolsuite({Key? key}) : super(key: key);

  @override
  _PoolsuiteState createState() => _PoolsuiteState();
}

class _PoolsuiteState extends State<Poolsuite> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            initialUrl: "https://www.poolsuite.net",
            onWebViewCreated: (WebViewController controller) async {
              while (true) {
                await Future.delayed(Duration(seconds: 2));
                final isLoaded = await controller.evaluateJavascript(
                    "!!document.querySelector('.is-launcher li')");

                log("checking for loaded!");
                if (isLoaded == 'true') break;
              }

              await controller.evaluateJavascript(
                  "document.querySelector('.is-launcher li').click()");
            },
          ))
        ]);
  }
}
