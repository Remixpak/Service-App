import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;

  ConnectionService._internal();

  bool _isOnline = true;

  Future<bool> checkOnline() async {
    final result = await Connectivity().checkConnectivity();
    print("DEBUG - ConnectivityResult: $result");

    if (result == ConnectivityResult.none) {
      _isOnline = false;
      print("DEBUG - _isOnline set to FALSE because result is NONE");
      return false;
    }

    //verificamos atravez de internet
    final hasInternet = await _hasInternetAccess();
    _isOnline = hasInternet;
    print("DEBUG - _isOnline (after HTTP check): $_isOnline");

    return _isOnline;
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final response = await HttpClient()
          .getUrl(Uri.parse('https://clients3.google.com/generate_204'))
          .then((req) => req.close());

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  bool get isOnline => _isOnline;
}
