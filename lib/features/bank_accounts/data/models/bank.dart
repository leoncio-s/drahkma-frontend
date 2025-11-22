class Banks {
  final String? _ispb;
  final String? _name;
  final int? _code;
  final String? _fullName;

  Banks(this._ispb, this._name, this._code, this._fullName);

  String? get ispb => _ispb;
  String? get name => _name;
  int? get code => _code;
  String? get fullName => _fullName;


  factory Banks.fromJson(Map<String, dynamic> json){
    return Banks(json['ispb'], json['name'], json['code'], json['fullName']);
  }
}