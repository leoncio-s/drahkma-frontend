import 'package:intl/intl.dart';

String currencyBRLFormat(double value, {String symbol=""}){
  return NumberFormat.currency(locale: "pt-BR", decimalDigits: 2, symbol: symbol).format(value);
}