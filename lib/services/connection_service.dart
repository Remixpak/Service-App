import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;

  ConnectionService._internal() {
    Connectivity().onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
    });
  }

  bool _isOnline = true;

  Future<bool> checkOnline() async {
    final result = await Connectivity().checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    return _isOnline;
  }

  bool get isOnline => _isOnline;
}
