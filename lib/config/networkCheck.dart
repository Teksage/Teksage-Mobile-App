import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal();

  final ValueNotifier<bool?> internetStatus = ValueNotifier(null);
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _controller.stream;

  StreamSubscription<InternetStatus>? _internetStatusSub;

  void initialize() async {
    _setStatus(null); // loading
    final hasInternet = await InternetConnection().hasInternetAccess;
    _setStatus(hasInternet);

    _internetStatusSub = InternetConnection().onStatusChange.listen((status) async {
      _setStatus(null); // loading
      final hasAccess = await InternetConnection().hasInternetAccess;
      _setStatus(hasAccess);
    });
  }

  void updateConnectionStatus(bool isConnected) {
    _setStatus(isConnected);
  }

  void _setStatus(bool? value) {
    internetStatus.value = value;
    if (value != null) {
      _controller.add(value);
    }
  }

  void dispose() {
    _internetStatusSub?.cancel();
    _controller.close();
  }
}
