abstract class Services<T>{
  Future get();
  Future save(T data);
  Future update(T data);
  Future delete(T data);
}