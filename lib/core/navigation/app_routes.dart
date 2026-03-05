import 'package:drahkma/core/presentation/pages/default_error_page.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/amount/presentation/pages/dashboard_amount_page.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_get_saved_email_use_case.dart';
import 'package:drahkma/features/auth/presentation/pages/auth_page.dart';
import 'package:drahkma/features/auth/presentation/pages/forget_password_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Map<String, Widget Function(BuildContext)> routes =
  {
    'login': (context) => AuthPage(getIt(), getIt<AuthGetSavedEmailUseCase>()),
    'dashboard': (context) => DashboardAmountPage(),
    'forget-password': (context) => ForgetPasswordPage(),
    'error-page':(context)=>DefaultErrorPage()
  };
}