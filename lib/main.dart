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

class _PoolsuiteState extends State<Poolsuite> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    // NB: If you background the app, the HTML5 audio keeps playing but doesn't
    // get enough CPU time and it starts dropping out / sounding absolutely
    // horrendous
    if (_lastLifecycleState != AppLifecycleState.resumed) {
      return Container();
    }

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
                if (_lastLifecycleState != AppLifecycleState.resumed) {
                  return;
                }

                final isLoaded = await controller.evaluateJavascript(
                    "!!document.querySelector('.is-launcher li')");

                log("checking for loaded!");
                if (isLoaded == 'true') break;
              }

              if (_lastLifecycleState != AppLifecycleState.resumed) {
                return;
              }

              await controller.evaluateJavascript(
                  "document.querySelector('.is-launcher li').click()");
            },
          ))
        ]);
  }
}
