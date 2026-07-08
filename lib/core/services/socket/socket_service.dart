import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app/constants/api_end_point.dart';
import '../../storage/storage_services.dart';
import '../../utils/logger.dart';

class SocketService {
  SocketService._();

  static io.Socket? _socket;

  /// Socket connection state
  static bool get isConnected => _socket?.connected ?? false;

  /// ================= CONNECT =================
  static void connect() {
    if (isConnected) return;
    logInfo('🔌 Initializing socket connection');

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
      ..onConnect((_) => logInfo('Socket connected'))
      ..onDisconnect((_) => logWarning('Socket disconnected'))
      ..onReconnectAttempt(
        (attempt) => logWarning('Reconnect attempt: $attempt'),
      )
      ..onReconnectFailed(
        (_) => logWarning('Reconnect failed(max attempts hit)'),
      )
      ..onConnectError((e) => logError(' Connect error: $e'))
      ..onError((e) => logError('Socket error: $e'));
  }

  /// ================= USER NOTIFICATION =================
  static void _registerUserNotificationListener() {
    final userId = LocalStorage.user.id;
    if (_socket == null || userId.isEmpty) {
      logWarning('User ID not available. Notification listener skipped.');
      return;
    }
    final event = 'user-notification::$userId';
    _socket!
      ..off(event) // Remove Previous listeners
      ..on(event, (data) {
        logDebug('User notification: $data');
        // NotificationService.show(...)
      });
  }

  /// ================= LISTEN =================
  static void on(String event, void Function(dynamic data) handler) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      logError('Cannot listen. Socket not connected. Event: $event');
      return;
    }

    socket
      ..off(event)
      ..on(event, handler);
  }

  /// ================= LISTEN =================
  static void off(String event) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      logError('Cannot listen. Socket not connected. Event: $event');
      return;
    }

    socket.off(event);
  }

  /// ================= EMIT =================
  static void emit(String event, dynamic data) {
    final socket = _getConnectedSocket();
    if (socket == null) {
      logError('Emit failed. Socket not connected. Event: $event');
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
      logError('EmitWithAck failed. Socket not connected. Event: $event');
      return;
    }

    socket.emitWithAck(event, data, ack: onAck);
  }

  /// ================= DISCONNECT =================
  static void disconnect() {
    final socket = _socket;
    if (socket == null) return;
    logInfo('🔌 Socket disconnected manually');
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
      logInfo('Socket exists but not connected yet');
      return null;
    }
    return _socket;
  }
}
