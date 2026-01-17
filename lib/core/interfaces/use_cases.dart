abstract interface class UseCases<T> {

  Future<T?> call();
}