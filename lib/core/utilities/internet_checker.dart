import 'dart:io';

class InternetChecker {
  static final InternetChecker _singleton = InternetChecker._internal();

  InternetChecker._internal();

  static InternetChecker getInstance() => _singleton;

  Future<bool> checkConnection() async {
    var hasConnection = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    return hasConnection;
  }
}
