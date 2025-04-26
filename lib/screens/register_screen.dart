import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/sign_up_request.dart';
import '../providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import '../widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _gender;
  DateTime? _selectedDate;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = SignUpRequest(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _gender!,
        dob: _selectedDate!,
        address:
            _addressController.text.isEmpty ? null : _addressController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      final email = await Provider.of<AuthProvider>(context, listen: false)
          .signUp(request);
      Navigator.pushNamed(
        context,
        '/otp-verification',
        arguments: {
          'email': email,
          'isForRegistration': true,
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
                            'Tạo tài khoản',
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
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Họ và tên',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập họ và tên';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: 16),
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
                              if (!EmailValidator.validate(value)) {
                                return 'Định dạng email không hợp lệ';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 900.ms)
                              .slideX(begin: 0.2),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Số điện thoại',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(
                              labelText: 'Giới tính',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            items: ['MALE', 'FEMALE']
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child:
                                          Text(gender == 'MALE' ? 'Nam' : 'Nữ'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Vui lòng chọn giới tính';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 1100.ms)
                              .slideX(begin: 0.2),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _dobController,
                            decoration: InputDecoration(
                              labelText: 'Ngày sinh',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn ngày sinh';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 1200.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Địa chỉ (Tùy chọn)',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 1300.ms)
                              .slideX(begin: 0.2),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 1400.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng xác nhận mật khẩu';
                              }
                              if (value != _passwordController.text) {
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(duration: 1500.ms)
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
                          ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
                            child: Text('Đăng ký'),
                          ).animate().fadeIn(duration: 1600.ms),
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
