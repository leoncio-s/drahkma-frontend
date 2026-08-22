import 'package:drahkma/core/presentation/pages/default_error_page.dart';
import 'package:drahkma/core/presentation/theme/app_theme.dart';
import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_get_saved_email_use_case.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:drahkma/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';


class Drahkma extends StatelessWidget {
  final String initialRoute;
  const Drahkma({super.key, this.initialRoute=AppRoutes.login});

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: AppRoutes.navigatorKey,
        title: "Drahkma",
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        initialRoute: initialRoute,
        onGenerateRoute: (settings){
          if(settings.name != null)
          {
            final uri = Uri.parse(settings.name!);
            final queryParams = uri.queryParameters; // Map<String, String>
            final path = uri.path;
            
            if(queryParams.containsKey('message'))
            {
              RouteSettings settings = RouteSettings(name: "/login", arguments: queryParams);
              return MaterialPageRoute(builder: (context)=>AuthPage(getIt<AuthController>(), getIt<AuthGetSavedEmailUseCase>()), settings: settings);
            }
            if(AppRoutes.routes.containsKey(path)){
              return MaterialPageRoute(builder: AppRoutes.routes[path]!, settings: settings);
            }
          }
          return MaterialPageRoute(builder: (context)=>DefaultErrorPage(message: "Página não encontrada", route: AppRoutes.login,), settings: settings);
        },
        onUnknownRoute: (settings){
          return MaterialPageRoute(builder: (context) => DefaultErrorPage(message: "Página não encontrada", route: AppRoutes.login,));
        },
      );
}
