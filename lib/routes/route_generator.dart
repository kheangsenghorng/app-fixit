
import 'package:fixit/features/auth/ui/login_sheet.dart';
import 'package:fixit/features/auth/ui/sign_up_sheet.dart';
import 'package:fixit/features/onboarding_screen/onboarding_screen.dart';
import 'package:fixit/features/splash_screen/splash_screen_widget.dart';
import 'package:fixit/features/user/main_screen.dart';
import 'package:fixit/features/user/profile/appearance/appearance_screen.dart';
import 'package:fixit/features/user/profile/edit/edit_profile_screen.dart';
import 'package:fixit/features/user/profile/helpsupport/help_support_screen.dart';
import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:fixit/features/user/service_provider_detail/provider_detail_screen.dart';
import 'package:fixit/features/user/review_summary/review_summary_screen.dart';

import 'package:fixit/unsupported_screen.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreenWidget(),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginSheet(),
        );

      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpSheet(),
        );
      // case AppRoutes.home:
      //   return MaterialPageRoute(
      //     builder: (_) => const HomeScreen(),
      //   );
        case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );

      case AppRoutes.unsupported:
        return MaterialPageRoute(
          builder: (_) => const UnsupportedScreen(),
        );

      case AppRoutes.search:
      return MaterialPageRoute(
        builder: (_) => const SearchResultScreen(),
      );

      case AppRoutes.providerDetail:
       return MaterialPageRoute(
         settings: settings,
        builder: (_) => const ProviderDetailScreen(),
      );

      case AppRoutes.popularServices:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
      );

      case AppRoutes.addService:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
      );

      case AppRoutes.reviewSummary:
        return MaterialPageRoute(
          settings: settings, // preserves arguments explicitly
          builder: (_) => const ReviewSummaryScreen(),
        );
        case AppRoutes.myOrders:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
        case AppRoutes.orderDetail:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );

        case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
        case AppRoutes.editProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const EditProfileScreen(),
        );
        case AppRoutes.appearance:
        return MaterialPageRoute(
          builder: (_) => const AppearanceScreen(),
        );
        case AppRoutes.helpSupport:
        return MaterialPageRoute(
          builder: (_) => const HelpSupportScreen(),
        );
       default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
