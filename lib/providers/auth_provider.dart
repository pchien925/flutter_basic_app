import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/sign_up_request.dart';
import '../models/sign_in_request.dart';
import '../models/verify_otp_request.dart';
import '../models/send_otp_request.dart';
import '../models/set_password_request.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  Future<String> signUp(SignUpRequest request) async {
    try {
      _user = await _authService.signUp(request);
      notifyListeners();
      return request.email; // Trả về email để chuyển hướng
    } catch (e) {
      throw e;
    }
  }

  Future<void> signIn(SignInRequest request) async {
    try {
      _user = await _authService.signIn(request);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> refreshToken(String refreshToken) async {
    try {
      final tokenResponse = await _authService.refreshToken(refreshToken);
      _user = User(
        email: _user?.email ?? '',
        id: tokenResponse.userId,
        token: tokenResponse.accessToken,
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> verifyEmail(VerifyOtpRequest request) async {
    try {
      await _authService.verifyEmail(request);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> sendOtpForForgotPassword(SendOtpRequest request) async {
    try {
      await _authService.sendOtpForForgotPassword(request);
    } catch (e) {
      throw e;
    }
  }

  Future<String> verifyOtpForForgotPassword(VerifyOtpRequest request) async {
    try {
      return await _authService.verifyOtpForForgotPassword(request);
    } catch (e) {
      throw e;
    }
  }

  Future<void> resetForgotPassword(
    String verificationToken,
    SetPasswordRequest request,
  ) async {
    try {
      await _authService.resetForgotPassword(verificationToken, request);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
