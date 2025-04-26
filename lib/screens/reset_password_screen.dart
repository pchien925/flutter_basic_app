import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/set_password_request.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String verificationToken;

  ResetPasswordScreen({required this.email, required this.verificationToken});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = SetPasswordRequest(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      await Provider.of<AuthProvider>(context, listen: false)
          .resetForgotPassword(widget.verificationToken, request);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.2),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: -0.2),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        )
                            .animate()
                            .fadeIn(duration: 1000.ms)
                            .slideX(begin: 0.2),
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 24),
                        _isLoading
                            ? SpinKitThreeBounce(color: Colors.blue)
                            : ElevatedButton(
                                onPressed: _resetPassword,
                                child: Text('Reset Password'),
                              ).animate().fadeIn(duration: 1200.ms),
                      ],
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
