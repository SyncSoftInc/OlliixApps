part of 'main.dart';

const _storage = FlutterSecureStorage();

Future<JSResult> secureStorageHandler(List<String> args) async {
  final result = JSResult();
  if (args.length < 3) {
    result.Error = "Invalid args";
    return result;
  }

  var cmd = args[1];

  if (cmd == "get") {
    final key = args[2];

    try {
      result.Value = await _storage.read(key: key) ?? "";
      result.Success = true;
    } catch (e) {
      result.Error = e.toString();
      FLog.error(text: e.toString());
    }
  } else if (cmd == "set" && args.length > 2) {
    final key = args[2];
    final value = args[3];

    try {
      await _storage.write(key: key, value: value);
      result.Value = value;
      result.Success = true;
    } catch (e) {
      result.Error = e.toString();
      FLog.error(text: e.toString());
    }
  }

  return result;
}
