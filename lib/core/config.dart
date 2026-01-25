import 'package:intl/intl.dart';
// import 'package:web/web.dart' as html;

class Config{
  // static String urlApi= "${html.window.location.origin}/public/api/v1/";
  static String urlApi = 'http://localhost:8081/api/v1/';
  static String keyStorageAuthToken = "_auth_token";
  static String keyStorageEmail = '_email';

  static set setUrlApi(String value){
    urlApi = Uri.parse(value).toString();
  }

  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final NumberFormat currencyFormat =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
}