class UnprocessableEntityModel {
  final Map<String, dynamic> errors;
  final Map<String, dynamic> data;
  UnprocessableEntityModel(this.data, this.errors);

  factory UnprocessableEntityModel.fromJson(Map<String, dynamic> data)
  {
    return UnprocessableEntityModel(data['data'], data['errors']);
  }
}