part of 'main.dart';

Future<JSResult> refresh(InAppWebViewController? controller) async {
  final result = JSResult();

  try {
    await controller?.reload();
    result.Success = true;
  } catch (err) {
    result.Error = err.toString();
    FLog.error(text: result.Error);
  }

  return result;
}
