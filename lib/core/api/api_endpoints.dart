import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true;

  static const String compIpAddress = "192.168.1.66";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:3000/api/v1';
    }
    // if android
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  //Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String updateUser = '/auth/users/'; // append /:id
  static const String whoami = '/auth/whoami';
  static const String updateProfile = '/auth/update-profile';
  static const String requestPasswordReset = '/auth/request-password-reset';
  static const String resetPassword = '/auth/reset-password/'; // append /:token
  static const String logout = '/auth/logout';
}
