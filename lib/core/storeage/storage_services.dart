import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/router.dart';
import '../../features/profile/data/model/user_model.dart';
import '../services/socket/socket_service.dart';
import '../utils/logger.dart';
import 'storage_keys.dart';

class LocalStorage {
  LocalStorage._();

  /// SharedPreferences instance
  static SharedPreferences? _preferences;

  static String token = '';
  static String refreshToken = '';
  static UserModel _user = UserModel.empty;

  /// Get current user
  static UserModel get user => _user;

  static bool get isLogin => token.isNotEmpty;

  /// Initialize SharedPreferences (call once in main)
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    await _loadAllData();
  }

  /// Get storage instance
  static SharedPreferences get _storage => _preferences!;

  /// Load all saved data from SharedPreferences
  static Future<void> _loadAllData() async {
    token = _storage.getString(LocalStorageKeys.token) ?? '';
    refreshToken = _storage.getString(LocalStorageKeys.refreshToken) ?? '';

    final userString = _storage.getString(LocalStorageKeys.user);

    if (userString != null) {
      _user = UserModel.fromJson(jsonDecode(userString));
    }

    appLog(token, source: 'LocalStorage');
  }

  /// Save token
  static Future<void> saveToken(String? value) async {
    if (value == null || value.isEmpty) {
      appLog(' Token is  : $value');
      return;
    }
    token = value;
    await _storage.setString(LocalStorageKeys.token, value);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String? value) async {
    if (value == null || value.isEmpty) {
      appLog('Refresh Token is  : $value');
      return;
    }
    refreshToken = value;
    await _storage.setString(LocalStorageKeys.refreshToken, value);
  }

  /// Save full user model
  static Future<void> saveUser(Map<String, dynamic>? json) async {
    _user = UserModel.fromJson(json);
    await _storage.setString(LocalStorageKeys.user, jsonEncode(_user.toMap()));
  }

  /// Remove all data from SharedPreferences
  static Future<void> clear() async {
    await _storage.clear();
    token = '';
    refreshToken = '';
    _user = UserModel.empty;
  }

  /// Logout user, clear storage and disconnect socket
  static Future<void> logout() async {
    SocketService.disconnect();
    await clear();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
