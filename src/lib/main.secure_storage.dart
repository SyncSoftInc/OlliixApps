part of 'main.dart';

const _storage = FlutterSecureStorage();

Future<JSResult> secureStorageHandler(List<String> args) async {
  final result = JSResult();
  if (args.length < 3) {
    result.error = "Invalid args";
    return result;
  }

  var cmd = args[1];

  if (cmd == "get") {
    final key = args[2];

    try {
      result.value = await _storage.read(key: key) ?? "";
      result.success = true;
    } catch (e) {
      result.error = e.toString();
      FLog.error(text: e.toString());
    }
  } else if (cmd == "set" && args.length > 2) {
    final key = args[2];
    final value = args[3];

    try {
      await _storage.write(key: key, value: value);
      result.value = value;
      result.success = true;
    } catch (e) {
      result.error = e.toString();
      FLog.error(text: e.toString());
    }
  }

  return result;
}
