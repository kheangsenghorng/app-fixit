import 'package:fixit/features/auth/presentation/ui/login_sheet.dart';
import 'package:fixit/features/auth/presentation/ui/sign_up_sheet.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/ui/otp/otp_screen.dart';
import '../features/onboarding_screen/onboarding_screen.dart';
import '../features/splash_screen/splash_screen_widget.dart';
import '../features/user/main_screen.dart';
import '../features/user/orders/details/order_details_screen.dart';
import '../features/user/payment/payment_screen.dart';
import '../features/user/profile/appearance/appearance_screen.dart';
import '../features/user/profile/edit/edit_profile_screen.dart';

import '../features/user/profile/help_support/help_support_screen.dart';
import '../features/user/review_summary/review_summary_screen.dart';
import '../features/user/service_provider_detail/provider_detail_screen.dart';
import '../unsupported_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Helper to keep code DRY (Don't Repeat Yourself)
    MaterialPageRoute buildRoute(Widget child) {
      return MaterialPageRoute(settings: settings, builder: (_) => child);
    }

    switch (settings.name) {
    // 🚀 Splash & Onboarding
      case AppRoutes.splash: return buildRoute(const SplashScreenWidget());
      case AppRoutes.onboarding: return buildRoute(const OnboardingScreen());

    // 🔐 Auth Feature
      case AppRoutes.login: return buildRoute(const LoginSheet());
      case AppRoutes.signup: return buildRoute(const SignUpSheet());

    // 🏠 Core App Structure
      case AppRoutes.main:
      case AppRoutes.popularServices:
      case AppRoutes.addService:
      case AppRoutes.myOrders:
      case AppRoutes.profile:
        return buildRoute(const MainScreen());

    // 👤 Profile & Settings
      case AppRoutes.editProfile: return buildRoute(const EditProfileScreen());
      case AppRoutes.appearance: return buildRoute(const AppearanceScreen());
      case AppRoutes.helpSupport: return buildRoute(const HelpSupportScreen());

    // 🛠 Service & Bookings
      case AppRoutes.providerDetail: return buildRoute(const ProviderDetailScreen());
      case AppRoutes.reviewSummary: return buildRoute(const ReviewSummaryScreen());
      case AppRoutes.orderDetails: return buildRoute(const OrderDetailsScreen());

    // 💳 Payments
      case AppRoutes.payment: return buildRoute(const PaymentScreen());

    // Otp
    // ✅ Updated Otp Case
      case AppRoutes.otp:
        final args = settings.arguments as Map<String, dynamic>?;
        return buildRoute(
          OtpScreen(
            phone: args?['phone'] ?? '',
            password: args?['password'] ?? '',
          ),
        );

    // ⚠️ Error Handling
      case AppRoutes.unsupported: return buildRoute(const UnsupportedScreen());
      default: return _errorRoute();


    }

  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}