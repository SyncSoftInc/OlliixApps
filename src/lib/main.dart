import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olliix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final _skipSSLError = ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
  PullToRefreshController? _pullToRefreshController;
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    _pullToRefreshController = PullToRefreshController(onRefresh: () async {
      await _webViewController?.reload();
      await _pullToRefreshController?.endRefreshing();
    }); // 下拉刷新

    return WillPopScope(
      child: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("https://www.olliix.com")),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(userAgent: "OlliixApp"),
          ),
          onReceivedServerTrustAuthRequest: (controller, challenge) async => _skipSSLError,
          pullToRefreshController: _pullToRefreshController,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            controller.addJavaScriptHandler(
                handlerName: 'native',
                callback: (args) {
                  // print arguments coming from the JavaScript side!
                  // print(args);
                  // return data to the JavaScript side!
                  return {'bar': 'bar_value', 'baz': 'baz_value'};
                });
          },
          // onLoadStart: (controller, url) {
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint(consoleMessage.message);
          },
        ),
      ),
      onWillPop: () async {
        bool canNavigate = await _webViewController?.canGoBack() ?? false;
        if (canNavigate) {
          _webViewController?.goBack();
          return false;
        } else {
          return true;
        }
      },
    );
  }
}
