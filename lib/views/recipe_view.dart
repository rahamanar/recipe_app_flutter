import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String url;

  RecipeView(this.url);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  /*TODO: Need to work on web view its throwing error
    Unsupported operation: Trying to use the default webview implementation for 
   TargetPlatform.windows [ +1 ms] but there isn't a default one [ +12 ms] 
   The relevant error-causing widget was: [ +1 ms] WebView*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe"),
      ),
      body: WebView(
        initialUrl: widget.url,
        onWebViewCreated: (controller) {
          _completer.complete(controller);
        },
      ),
    );
  }
}
