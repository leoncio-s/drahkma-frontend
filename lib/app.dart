import 'package:drahkma/core/presentation/pages/default_error_page.dart';
import 'package:drahkma/core/presentation/theme/app_theme.dart';
import 'package:drahkma/core/navigation/app_routes.dart';
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
        onUnknownRoute: (settings){
          return MaterialPageRoute(builder: (context) => DefaultErrorPage(message: "Página não encontrada", route: AppRoutes.login,));
        },
      );
}
