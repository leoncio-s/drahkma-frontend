abstract class DtoInterface {
  DtoInterface();
  factory DtoInterface.toObject(Map<String, dynamic> data){
    throw UnimplementedError();
  }
  Map toMap();
}