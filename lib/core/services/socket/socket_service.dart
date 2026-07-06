import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app/constants/api_end_point.dart';
import '../../storeage/storage_services.dart';
import '../../utils/logger.dart';

class SocketService {
  SocketService._();

  static io.Socket? _socket;

  /// Socket connection state
  static bool get isConnected => _socket?.connected ?? false;

  /// ================= CONNECT =================
  static void connect() {
    if (isConnected) return;
    appLog('🔌 Initializing socket connection');

    _socket = io.io(
      ApiEndPoint.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5) // max 5 retries
          .setReconnectionDelay(2000) // 2 sec
          .setReconnectionDelayMax(5000) // max 5 sec
          .build(),
    );

    _registerCoreListeners();
    _registerUserNotificationListener();

    _socket?.connect();
  }

  /// ================= CORE LISTENERS =================
  static void _registerCoreListeners() {
    final socket = _socket;
    if (socket == null) return;
    socket
      ..onConnect((_) => appLog('✅ Socket connected'))
      ..onDisconnect((_) => appLog('⚠️ Socket disconnected'))
      ..onReconnectAttempt((attempt) => appLog('🔄Reconnect attempt: $attempt'))
      ..onReconnectFailed((_) => appLog('❌Reconnect failed(max attempts hit)'))
      ..onConnectError((e) => appLog('❌ Connect error: $e'))
      ..onError((e) => appLog('❌ Socket error: $e'));
  }

  /// ================= USER NOTIFICATION =================
  static void _registerUserNotificationListener() {
    final userId = LocalStorage.user.id;
    if (_socket == null || userId.isEmpty) {
      appLog('⚠️ User ID not available. Notification listener skipped.');
      return;
    }
    final event = 'user-notification::$userId';
    _socket!
      ..off(event) // Remove Previous listeners
      ..on(event, (data) {
        appLog('📩 User notification: $data');
        // NotificationService.show(...)
      });
  }

  /// ================= LISTEN =================
  static void on(String event, void Function(dynamic data) handler) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      appLog('❌ Cannot listen. Socket not connected. Event: $event');
      return;
    }

    socket
      ..off(event) // Remove Previous listeners
      ..on(event, handler);
  }

  /// ================= EMIT =================
  static void emit(String event, dynamic data) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      appLog('❌ Emit failed. Socket not connected. Event: $event');
      return;
    }

    socket.emit(event, data);
  }

  /// ================= EMIT WITH ACK =================
  static void emitWithAck(
    String event,
    Map<String, dynamic> data,
    void Function(dynamic ackData) onAck,
  ) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      appLog('❌ EmitWithAck failed. Socket not connected. Event: $event');
      return;
    }

    socket.emitWithAck(event, data, ack: onAck);
  }

  /// ================= DISCONNECT =================
  static void disconnect() {
    final socket = _socket;
    if (socket == null) return;
    appLog('🔌 Socket disconnected manually');
    socket
      ..clearListeners()
      ..disconnect();
    _socket = null;
  }

  /// ================= INTERNAL =================
  static io.Socket? _getConnectedSocket() {
    if (_socket == null) {
      connect();
      return null;
    }
    if (!_socket!.connected) {
      appLog('⚠️ Socket exists but not connected yet');
      return null;
    }
    return _socket;
  }
}
