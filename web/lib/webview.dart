import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String selectedUrl;

  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  MyWebView({
    @required this.selectedUrl,
  });

  void alert(BuildContext context, String msg) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> scan(BuildContext context, String purpos) async {
    print(purpos);
    var result = await BarcodeScanner.scan();

    await _completer.future.then((controller) {
      controller
          .evaluateJavascript("Callback('Scan:" + result.rawContent + "')");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      initialUrl: selectedUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _completer.complete(webViewController);
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
          name: "native",
          onMessageReceived: (params) async {
            List<String> array = params.message.split(":");

            if (array.length == 0) {
              return;
            }

            switch (array[0]) {
              case "Scan":
                await scan(context, array[1]);
                break;
            }
          },
        )
      ]),
    ));
  }
}
