class BanksDto {
  final String? _ispb;
  final String? _name;
  final int? _code;
  final String? _fullName;

  BanksDto(this._ispb, this._name, this._code, this._fullName);

  String? get ispb => _ispb;
  String? get name => _name;
  int? get code => _code;
  String? get fullName => _fullName;


  factory BanksDto.fromJson(Map<String, dynamic> json){
    return BanksDto(json['ispb'], json['name'], json['code'], json['fullName']);
  }
}