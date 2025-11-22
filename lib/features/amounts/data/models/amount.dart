class Amount{
  double? total = 0.0;
  String? description = "";
  Amount({this.total, this.description});

  factory Amount.fromJson(Map<String, dynamic> data){
    return Amount(
      total: data['total'],
      description: data['description']
    );
  }

  @override
  String toString(){
    return {
      'total' : total,
      'description' : description,
    }.toString();
  }
}