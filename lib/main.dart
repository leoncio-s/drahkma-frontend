import 'package:drahkma/Auth/login_page.dart';
import 'package:drahkma/User/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/home.dart';

void main() async {
  String initialRoute = "/auth/login";

  if(kDebugMode){
    Config.setUrlApi = "http://localhost:8081/public/api/v1/";
  }

  try{
    await UserService.profile();
    initialRoute = "/dashboard";
  }catch(e){
    initialRoute = "/auth/login";
  }
  
  try{
    runApp(LFinanca(initialRoute: initialRoute,));

  }catch(e){
    print(e);
  }
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

  Color yellowMainColor = const Color(0xFFDE9D32);
  Color backgroundColorBlue = const Color(0xFF00101D);
  Color blueColor = const Color(0xFF003057);

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
      color: yellowMainColor,
      theme: ThemeData(
        fontFamily: "OpenSans",
        brightness: Brightness.dark,
        useMaterial3: false,
        primaryColor: backgroundColorBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColorDark: backgroundColorBlue,
        hoverColor: const Color.fromRGBO(0, 48, 87, 1),
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: yellowMainColor,
          tertiary: const Color.fromRGBO(0, 48, 87, 1),
        ),
        cardColor: Colors.black,
        secondaryHeaderColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white, selectionColor: Color(0xFFDE9D32)),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.w100
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(width: 2.0, color: Colors.red)),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 15),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(
                  strokeAlign: 10, width: 3.0, color: yellowMainColor)),
          constraints: const BoxConstraints(minHeight: 30, minWidth: 200),
          focusColor: yellowMainColor,
          fillColor: null,
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(
                  strokeAlign: 10, width: 3.0, color: yellowMainColor)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(
                  strokeAlign: 10, width: 3.0, color: Colors.white)),
          counterStyle: const TextStyle(color: Colors.white, inherit: false),
          contentPadding: const EdgeInsets.all(10.0),
          labelStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 15,
              color: Color.fromRGBO(222, 157, 50, 1)
              ),
        ),
        // buttonTheme: ButtonThemeData(
        //   buttonColor: yellowMainColor,
        //   hoverColor: const Color.fromRGBO(0, 48, 87, 1)
        // ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: null,
          ),
          textStyle: WidgetStateTextStyle.resolveWith((state){
            return const TextStyle(
              color: Colors.white
            );
          }),
          menuStyle: MenuStyle(
            shape: WidgetStateProperty.resolveWith((st)=>
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
              )
            ),
            
            backgroundColor: WidgetStateProperty.resolveWith<Color>((state){
              if(state.contains(WidgetState.hovered)){
                return const Color.fromRGBO(222, 157, 50, 1);
              }
              return Colors.white;
            }),
          ),
        )
        ,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> state){
              return blueColor;
            }),
            shape: WidgetStateProperty.resolveWith((state){
              return const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0))
              );
            }),
            textStyle: WidgetStateTextStyle.resolveWith((state){
              return const TextStyle(
                fontFamily: "OpenSans",
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 20
              );
            }),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> state){
              if(state.contains(WidgetState.hovered)){
                return Colors.white;
              }
              return yellowMainColor;
            })
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateTextStyle.resolveWith((state){
              return const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w100,
                      textBaseline: TextBaseline.alphabetic,
                      decoration: TextDecoration.underline,
                      fontSize: 18
                    );
            })
          )
        )
      ),
      routes: {
        '/auth/login' : (context) => LoginPage(),
        '/dashboard': (context) => const HomeView(),
      },
    );
  }
}
