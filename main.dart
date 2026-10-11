import 'package:flutter/material.dart';

import 'screens/account_verified_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/find_ride_screen.dart';
import 'screens/login_screen.dart';
import 'screens/rate_ride_screen.dart';
import 'screens/register_step1_screen.dart';
import 'screens/register_step2_screen.dart';
import 'screens/ride_status_screen.dart';
import 'screens/vehicle_details_screen.dart';
import 'screens/verify_otp_screen.dart';

// ============================================================
// Centralized route names
// ============================================================
class AppRoutes {
  static const String login = '/login';
  static const String registerStep1 = '/register_step1';
  static const String registerStep2 = '/register_step2';
  static const String verifyOtp = '/verify_otp';
  static const String accountVerified = '/account_verified';
  static const String dashboard = '/dashboard';
  static const String findRide = '/find_ride';
  static const String findRideAlt = '/find-ride'; // Alias to prevent route error
  static const String vehicleDetails = '/vehicle_details';
  static const String rideStatus = '/ride_status';
  static const String rateRide = '/rate_ride';
}

void main() {
  runApp(const ShareTripApp());
}

class ShareTripApp extends StatelessWidget {
  const ShareTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMDI ShareTrip',
      debugShowCheckedModeBanner: false,

      // ---------------- THEME ----------------
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF6C2BD9),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C2BD9),
          primary: const Color(0xFF6C2BD9),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C2BD9),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C2BD9),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C2BD9), width: 1.5),
          ),
        ),
      ),

      // ---------------- STARTING SCREEN ----------------
      initialRoute: AppRoutes.login,

      // ---------------- ROUTES ----------------
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.registerStep1: (context) => const RegisterStep1Screen(),
        AppRoutes.registerStep2: (context) => const RegisterStep2Screen(),
        AppRoutes.verifyOtp: (context) => const VerifyOtpScreen(),
        AppRoutes.accountVerified: (context) => const AccountVerifiedScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.findRide: (context) => const FindRideScreen(),
        AppRoutes.findRideAlt: (context) => const FindRideScreen(), // Supports both '/find_ride' and '/find-ride'
        AppRoutes.vehicleDetails: (context) => const VehicleDetailsScreen(),
        AppRoutes.rideStatus: (context) => const RideStatusScreen(),
        AppRoutes.rateRide: (context) => const RateRideScreen(),
      },

      // ---------------- FALLBACK FOR UNKNOWN ROUTES ----------------
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _UnknownRouteScreen(routeName: settings.name),
        );
      },
    );
  }
}

// ============================================================
// Friendly fallback screen for unknown routes
// ============================================================
class _UnknownRouteScreen extends StatelessWidget {
  final String? routeName;

  const _UnknownRouteScreen({this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Route not found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'The route "${routeName ?? 'unknown'}" is not registered.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}