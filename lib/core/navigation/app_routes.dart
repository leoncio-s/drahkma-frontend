import 'package:drahkma/core/presentation/pages/default_error_page.dart';
import 'package:drahkma/core/presentation/pages/home.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_get_saved_email_use_case.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:drahkma/features/auth/presentation/pages/auth_page.dart';
import 'package:drahkma/features/auth/presentation/pages/forget_password_page.dart';
import 'package:drahkma/features/user/presentation/controllers/user_controller.dart';
import 'package:drahkma/features/user/presentation/pages/create_user_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Map<String, Widget Function(BuildContext)> routes =  {
    'login': (context) => AuthPage(getIt<AuthController>(), getIt<AuthGetSavedEmailUseCase>()),
    'dashboard': (context) => HomeView(),
    'forget-password': (context) => ForgetPasswordPage(authController: getIt<AuthController>()),
    'error-page': (context) => DefaultErrorPage(),
    'sign-in': (context) => CreateUserPage(getIt<UserController>()),
  };
}