class StringValidators{
  static bool sqlInjection(String? value){
    return value!.trim().startsWith("'") && RegExp(r"(((\+)|(\ ))(((\%27)|(\'))|union|select|delete|insert|or|alter|drop|and)(((\+)|(\ ))))", caseSensitive: false).hasMatch(value);
  }
}