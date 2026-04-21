import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Config{
  static String _urlApi = '${kDebugMode ? 'http://localhost:8081' :  kIsWeb ? Uri.base.origin : 'https://drahkma.leoncio.dev'}/api/v1/';
  static String keyStorageAuthToken = "_auth_token";
  static String keyStorageEmail = '_email';
  static String keyStorageUser = "_user_profile";
  static String keyStorageCards = "_cards";
  static String keyStorageCategories = "_categories";
  static String keyStorageItems = "_items";
  static String keyStorageBankAccounts = "_bank_accounts";
  static String keyStorageDashboard = "_dashboard";

  static set setUrlApi(String value){
    _urlApi = Uri.parse(value).toString();
  }
  static String get urlApi => _urlApi;

  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final NumberFormat currencyFormat =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
}