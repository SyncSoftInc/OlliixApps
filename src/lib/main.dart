import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:olliix/js_result.dart';
import 'package:f_logs/f_logs.dart';

part 'main.secure_storage.dart';
part 'main.refresh.dart';

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
  static const _url = "https://dw.olliix.com";
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
          initialUrlRequest: URLRequest(url: Uri.parse(_url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(userAgent: "OlliixApp"),
          ),
          onReceivedServerTrustAuthRequest: (controller, challenge) async => _skipSSLError, // 忽略证书错误
          pullToRefreshController: _pullToRefreshController,
          onWebViewCreated: (controller) {
            _webViewController = controller;

            // 添加js交互
            controller.addJavaScriptHandler(
                handlerName: 'native',
                callback: (args) async {
                  var r = JSResult();
                  final arrays = args[0].split(":");

                  if (arrays.isEmpty) {
                    r.Error = "args is empty";
                    return r;
                  }

                  var cmd = arrays[0];
                  switch (cmd) {
                    case "Refresh":
                      r = await refresh(_webViewController);
                      break;
                    case "SecureStorage":
                      r = await secureStorageHandler(arrays);
                      break;
                    default:
                      r = JSResult()..Error = "native command '$cmd' is not supported";
                  }

                  return r;
                });
          },
          // onLoadStart: (controller, url) {
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          onConsoleMessage: (controller, consoleMessage) {
            FLog.debug(text: consoleMessage.message);
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
