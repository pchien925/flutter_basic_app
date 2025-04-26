import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/sign_in_request.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = SignInRequest(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await Provider.of<AuthProvider>(context, listen: false).signIn(request);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
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
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: -0.2),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
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
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 900.ms)
                              .slideX(begin: 0.2),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            child: const Text('Đăng nhập'),
                          ).animate().fadeIn(duration: 1000.ms),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/register'),
                                child: const Text('Đăng kí'),
                              ).animate().fadeIn(duration: 1200.ms),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/forgot-password'),
                                child: const Text('Quên mật khẩu?'),
                              ).animate().fadeIn(duration: 1200.ms),
                            ],
                          ),
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
