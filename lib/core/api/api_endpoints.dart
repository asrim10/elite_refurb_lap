import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String compIpAddress = "192.168.1.66";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:3000/api/v1';
    }
    // if android
    if (kIsWeb) {
      return 'http://localhost:5050/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:5050/api';
    } else {
      return 'http://localhost:5050/api';
    }
  }

  /// The server host used to serve static files (images, uploads).
  /// Strips the API path suffix ("/api" or "/api/v1") from [baseUrl].
  static String get imageBaseUrl {
    final url = baseUrl;
    if (url.endsWith('/api/v1')) {
      return url.substring(0, url.length - '/api/v1'.length);
    }
    if (url.endsWith('/api')) {
      return url.substring(0, url.length - '/api'.length);
    }
    return url;
  }

  /// Converts a relative image path (e.g. "/uploads/file.jpg") to a full URL.
  static String getImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = imageBaseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$base$cleanPath';
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

  // Laptop Endpoints
  static const String laptops = '/laptops';
  static const String laptopMyListings = '/laptops/seller/my-listings';
  static const String laptopById = '/laptops/'; // append /:id
  static const String laptopBySeller = '/laptops/seller/'; // append /:sellerId
}
