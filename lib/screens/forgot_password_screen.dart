import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/send_otp_request.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = SendOtpRequest(email: _emailController.text);
      await Provider.of<AuthProvider>(context, listen: false)
          .sendOtpForForgotPassword(request);
      Navigator.pushNamed(
        context,
        '/otp-verification',
        arguments: {
          'email': _emailController.text,
          'isForRegistration': false,
        },
      );
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
                            'Quên mật khẩu',
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
                            'Nhập email để nhận mã OTP',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
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
                            onPressed: _isLoading ? null : _sendOtp,
                            child: Text('Gửi OTP'),
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
