import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/reset_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Food App Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.grey[100],
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
          '/home': (context) => Scaffold(
                appBar: AppBar(title: Text('Trang chủ')),
                body: Center(child: Text('Chào mừng đến với Food App!')),
              ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/otp-verification') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                email: args['email'],
                isForRegistration: args['isForRegistration'] ?? false,
              ),
            );
          }
          if (settings.name == '/reset-password') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: args['email'],
                verificationToken: args['verificationToken'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
