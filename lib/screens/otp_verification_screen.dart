import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/verify_otp_request.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_overlay.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool isForRegistration;

  OtpVerificationScreen({
    required this.email,
    this.isForRegistration = false,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request =
          VerifyOtpRequest(email: widget.email, otp: _otpController.text);
      if (widget.isForRegistration) {
        await Provider.of<AuthProvider>(context, listen: false)
            .verifyEmail(request);
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        final verificationToken =
            await Provider.of<AuthProvider>(context, listen: false)
                .verifyOtpForForgotPassword(request);
        Navigator.pushNamed(
          context,
          '/reset-password',
          arguments: {
            'email': widget.email,
            'verificationToken': verificationToken,
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[700]!, Colors.blue[200]!],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.isForRegistration
                                ? 'Xác minh Email'
                                : 'Xác minh OTP',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: -0.2),
                          SizedBox(height: 16),
                          Text(
                            'Mã OTP đã được gửi đến ${widget.email}',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: _otpController,
                            decoration: InputDecoration(
                              labelText: 'Nhập OTP',
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập OTP';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .slideX(begin: -0.2),
                          if (_errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            child: Text('Xác minh OTP'),
                          ).animate().fadeIn(duration: 1000.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
