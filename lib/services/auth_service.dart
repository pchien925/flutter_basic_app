import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/sign_up_request.dart';
import '../models/sign_in_request.dart';
import '../models/token_response.dart';
import '../models/verify_otp_request.dart';
import '../models/send_otp_request.dart';
import '../models/set_password_request.dart';

class AuthService {
  static const String baseUrl =
      'http://192.168.1.6:9990/api/v1/auth'; // Thay bằng URL backend thực tế

  // Sign Up
  Future<User> signUp(SignUpRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return User.fromJson(data);
    } else {
      throw Exception(
        'Failed to sign up: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Sign In
  Future<User> signIn(SignInRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final tokenResponse = TokenResponse.fromJson(data);
      final user = User(
        email: request.email,
        id: tokenResponse.userId,
        token: tokenResponse.accessToken,
      );
      await _saveToken(tokenResponse.accessToken, tokenResponse.refreshToken);
      return user;
    } else {
      throw Exception(
        'Failed to sign in: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Refresh Token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return TokenResponse.fromJson(data);
    } else {
      throw Exception(
        'Failed to refresh token: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Verify Email
  Future<void> verifyEmail(VerifyOtpRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to verify email: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Send OTP for Forgot Password
  Future<void> sendOtpForForgotPassword(SendOtpRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(
        'Failed to send OTP: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Verify OTP for Forgot Password
  Future<String> verifyOtpForForgotPassword(VerifyOtpRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data['verificationToken'];
    } else {
      throw Exception('Invalid OTP: ${jsonDecode(response.body)['message']}');
    }
  }

  // Reset Password
  Future<void> resetForgotPassword(
    String verificationToken,
    SetPasswordRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'X-Verification-Token': verificationToken,
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to reset password: ${jsonDecode(response.body)['message']}',
      );
    }
  }

  // Save Tokens
  Future<void> _saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Get Access Token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get Refresh Token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}
