import 'package:intl/intl.dart';

class Config{
  static String urlApi= "https://lfinanca.leoncio.dev/public/api/v1/";

  static set setUrlApi(String value){
    urlApi = Uri.parse(value).toString();
  }

  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final NumberFormat currencyFormat =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
}