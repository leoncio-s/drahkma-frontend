import 'dart:async';
import 'dart:developer';
import 'package:drahkma/app.dart';
import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/error/update_password_exception.dart';
import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/core/presentation/controllers/app_controller.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/core/presentation/dialogs/alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';

late AppController appController;

void exceptionHandler(Object e, StackTrace s) {
  final BuildContext? context = AppRoutes.navigatorKey.currentContext;

  if (context == null) {
    log(e.toString(), stackTrace: s);
    return;
  }

  try{
    if (e is UnauthenticatedException) {
    Navigator.of(context).pushReplacementNamed("login");
    } else if (e is UpdatePasswordException) {
      alertDialog<String>(context, e.message, title: "Erro ao atualizar senha");
    } else {
      log(e.toString(), stackTrace: s, level: 1, name: "Drahkma App");
      debugPrintStack(stackTrace: s);
      alertDialog<String>(context, e.toString(), title: "Format Invalid Error");
    }
  } catch (dialogError, e)
  {
    debugPrintStack(stackTrace: s, label: "Dialog Main Error Handler");
    log(e.toString(), stackTrace: s, level: 1, name: "Drahkma App");
  }
}

void main() async {

  runZonedGuarded<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDependencies();
    await getIt.allReady(timeout: Duration(seconds: 5));
    appController = getIt<AppController>();

    if (kDebugMode) {
      Config.setUrlApi = "http://localhost:8081/api/v1/";
    }
    await appController.checkNetwork();

    runApp(_buildApp());
  }, exceptionHandler);
}

Widget _buildApp() {
  return ValueListenableBuilder<AppState>(
      valueListenable: appController,
      builder: (ctx, state, _) {
        final String initialRoute =
            state is NoNetworkState ? "error-page" : "login";
        return Drahkma(
          initialRoute: initialRoute,
        );
      });
}
