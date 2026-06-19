import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';

class WebSocketService {
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool isConnected = false;
  bool _reconnecting = false;
  int _retryAttempt = 0;
  Completer<void>? _connectCompleter;
  final Queue<String> _pending = ListQueue();

  final String url;
  final Future<String?> Function() getToken;
  final Future<String?> Function() refreshToken;
  final void Function(String data) onData;
  final void Function()? onDone;
  final void Function(dynamic error)? onError;

  WebSocketService({
    required this.url,
    required this.getToken,
    required this.refreshToken,
    required this.onData,
    this.onDone,
    this.onError,
  });

  /// Connect to WebSocket
  Future<void> connect() async {
    if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
      return _connectCompleter!.future;
    }
    _connectCompleter = Completer<void>();

    final token = await getToken();
    if (kDebugMode) {
      print("🟢 Connecting to WebSocket...");
    }

    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
        pingInterval: const Duration(seconds: 20),
      );

      isConnected = true;
      _reconnecting = false;
      _retryAttempt = 0;
      if (kDebugMode) {
        print("✅ WebSocket connected");
      }

      _subscription = _channel!.stream.listen(
        (data) {
          if (kDebugMode) {
            print("📥 Received: $data");
          }
          onData(data);
        },
        onError: (error) async {
          isConnected = false;
          if (kDebugMode) {
            print("❌ WebSocket error: $error");
          }
          if (error.toString().contains("401") || error.toString().contains("token")) {
            await _handleTokenExpiryAndReconnect();
          } else {
            _scheduleReconnect();
            onError?.call(error);
          }
        },
        onDone: () async {
          isConnected = false;
          if (kDebugMode) {
            print("⚠️ WebSocket closed");
          }
          await _handleTokenExpiryAndReconnect(fallbackToBackoff: true);
          onDone?.call();
        },
        cancelOnError: true,
      );

      _flushPending();

      _connectCompleter?.complete();
    } catch (e) {
      isConnected = false;
      if (kDebugMode) {
        print("❌ Connect failed: $e");
      }
      _scheduleReconnect();
      onError?.call(e);
      _connectCompleter?.completeError(e);
    } finally {
      _connectCompleter = null;
    }
  }

  /// Refresh token & reconnect, else backoff
  Future<void> _handleTokenExpiryAndReconnect({bool fallbackToBackoff = false}) async {
    if (kDebugMode) {
      print("🔁 Attempting token refresh...");
    }
    try {
      final newToken = await refreshToken();
      if (newToken != null) {
        if (kDebugMode) {
          print("🔄Chat - Retrying with refreshed token...");
        }
        await _reconnectNow();
      } else if (fallbackToBackoff) {
        if (kDebugMode) {
          print("🚫Chat1 -  Token refresh failed. Backing off...");
        }
        _scheduleReconnect();
      } else {
        onError?.call("Token refresh failed");
      }
    } catch (e) {
      if (kDebugMode) {
        print("🚫Chat2 -  Token refresh exception: $e");
      }
      fallbackToBackoff ? _scheduleReconnect() : onError?.call("Token refresh failed: $e");
    }
  }

  /// Exponential backoff reconnect
  void _scheduleReconnect() {
    if (_reconnecting) return;
    _reconnecting = true;

    final delay = Duration(seconds: [1, 2, 4, 6, 8, 10][_retryAttempt.clamp(0, 5)]);
    _retryAttempt++;
    if (kDebugMode) {
      print("⏳ Reconnecting in ${delay.inSeconds}s (attempt $_retryAttempt)...");
    }

    Future.delayed(delay, _reconnectNow);
  }

  Future<void> _reconnectNow() async {
    await disconnect();
    await connect();
  }

  /// Ensure connection before sending
  Future<void> ensureConnected() async {
    if (isConnected) return;
    await _reconnectNow();
  }

  /// Send message, queue if disconnected
  Future<void> send(String message) async {
    if (isConnected && _channel != null) {
      if (kDebugMode) {
        print("📤 Sending: $message");
      }
      _channel!.sink.add(message);
      return;
    }

    if (kDebugMode) {
      print("⚠️ Offline. Queuing: $message");
    }
    _pending.add(message);

    try {
      await ensureConnected();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Reconnect failed: $e");
      }
    }

    if (isConnected) _flushPending();
  }

  /// Flush queued messages
  void _flushPending() {
    if (!isConnected || _channel == null || _pending.isEmpty) return;
    if (kDebugMode) {
      print("📦 Flushing ${_pending.length} queued message(s)...");
    }
    while (_pending.isNotEmpty) {
      final msg = _pending.removeFirst();
      try {
        _channel!.sink.add(msg);
      } catch (e) {
        if (kDebugMode) {
          print("❌ Failed to send queued message: $e");
        }
        _pending.addFirst(msg); // put back
        break;
      }
    }
  }

  /// Disconnect cleanly
  Future<void> disconnect() async {
    isConnected = false;
    if (kDebugMode) {
      print("🔌 Disconnecting...");
    }
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }
}
