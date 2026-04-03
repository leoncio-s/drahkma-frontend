abstract interface class AmountRemoteDatasource
{
  Future<Map<String, dynamic>?> fetchAmounts(DateTime startDate, DateTime endDate);
}
