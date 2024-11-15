import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:front_lfinanca/Auth/auth_view.dart';
import 'package:front_lfinanca/User/user_service.dart';
import 'package:front_lfinanca/config.dart';
import 'package:front_lfinanca/home.dart';

void main() async {
  String initialRoute;

  if(kDebugMode){
    Config.setUrlApi = "http://localhost:8080/api/v1";
  }

  try{
    var user = await UserService.profile();
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
      initialRoute: widget.initialRoute,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColorDark: Colors.black,
        hoverColor: Colors.lightBlue,
        brightness: Brightness.dark,
        cardColor: Colors.black,
        secondaryHeaderColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white, selectionColor: Colors.lightBlueAccent),
        inputDecorationTheme: const InputDecorationTheme(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red, fontSize: 15),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  strokeAlign: 10, width: 10.0, color: Colors.black)),
          constraints: BoxConstraints(minWidth: 15, minHeight: 200),
          focusColor: Colors.lightBlue,
          hoverColor: Color.fromARGB(255, 248, 248, 248),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.lightBlue)),
          counterStyle: TextStyle(color: Colors.black, inherit: false),
          contentPadding: EdgeInsets.all(5.0),
          labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Colors.lightBlueAccent),
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
