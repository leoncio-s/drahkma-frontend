extension StringValidators on String?{
  bool get isSqlInjection {
    return this!.trim().startsWith("'") && RegExp(r"(((\+)|(\ ))(((\%27)|(\'))|union|select|delete|insert|or|alter|drop|and)(((\+)|(\ ))))", caseSensitive: false).hasMatch(this!);
  }
}