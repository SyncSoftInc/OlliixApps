part of 'main.dart';

Future<JSResult> refreshHandler(InAppWebViewController? controller) async {
  final result = JSResult();

  try {
    await controller?.reload();
    result.success = true;
  } catch (err) {
    result.error = err.toString();
    FLog.error(text: result.error);
  }

  return result;
}
