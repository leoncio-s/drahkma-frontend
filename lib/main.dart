import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drahkma/Auth/auth_view.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/home.dart';

void main() async {
  String initialRoute;

  if(kDebugMode){
    Config.setUrlApi = "http://localhost:8081/public/api/v1/";
  }

  try{
    await UserService.profile();
    initialRoute = "/dashboard";
  }catch(e){
    initialRoute = "/auth/login";
  }
  runApp(LFinanca(initialRoute: initialRoute,));
}

// ignore: must_be_immutable
class LFinanca extends StatefulWidget {
  String initialRoute;
  LFinanca({super.key, required this.initialRoute});

  @override
  State<StatefulWidget> createState() => _MainApp();
}

class _MainApp extends State<LFinanca> {
  // const MainApp({super.key});

  // late String initialRoute = Wid;

  @override
  void initState() {
    // try{
    //   var user = await UserService.profile();
    //   setState(() {
    //     initialRoute = '/dashboard';
    //   });
    // }catch(e){
    //   null;
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drahkma - Gerenciamento Financeiro Inteligente",
      initialRoute: widget.initialRoute,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        fontFamily: "OpenSans",
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColorDark: Colors.black,
        hoverColor: Color.fromRGBO(0, 48, 87, 1),
        brightness: Brightness.dark,
        cardColor: Colors.black,
        secondaryHeaderColor: Color.fromRGBO(222, 157, 50, 1),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white, selectionColor: Color.fromRGBO(222, 157, 50, 1)),
        inputDecorationTheme: const InputDecorationTheme(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red, fontSize: 15),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  strokeAlign: 10, width: 10.0, color: Colors.black)),
          constraints: BoxConstraints(minWidth: 15, minHeight: 200),
          focusColor: Color.fromRGBO(222, 157, 50, 1),
          hoverColor: Color.fromARGB(255, 248, 248, 248),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color.fromRGBO(222, 157, 50, 1))),
          counterStyle: TextStyle(color: Colors.black, inherit: false),
          contentPadding: EdgeInsets.all(5.0),
          labelStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 15,
              color: Color.fromRGBO(222, 157, 50, 1)),
        ),
      ),
      routes: {
        // '/items' :(context) => Items(),
        // '/cards' : (context) => Cards(),
        // '/bank-accounts'  : (context) => BankAccounts(),
        // '/categories' : (context) => Categories(),
        '/auth/login': (context) => const Auth(),
        '/dashboard': (context) => const HomeView(),
        // '/auth/registry' : (context) => Registry(),
      },
      // home: const Scaffold(
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
