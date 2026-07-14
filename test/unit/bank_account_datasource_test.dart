import 'package:drahkma/features/bank_account/data/models/bank_model.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource_impl.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'bank_account_datasource_test.mocks.dart';

@GenerateMocks([], customMocks:[MockSpec<http.Client>(as: #MockHttpClient)])
void main(){
    final client = MockHttpClient();
    final BankAccountRemoteDatasource datasource = BankAccountRemoteDatasourceImpl(client);
    group('fetchBanks',(){
      test('should return a valid list of banks',() async {

        when(
          client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1")),
        ).thenAnswer(
          (_) async =>
          http.Response('[{"ispb":"00000000","name":"BCO DO BRASIL S.A.","code":1,"fullName":"Banco do Brasil S.A."},{"ispb":"00000208","name":"BRB - BCO DE BRASILIA S.A.","code":70,"fullName":"BRB - BANCO DE BRASILIA S.A."},{"ispb":"00038121","name":"Selic","code":null,"fullName":"Banco Central do Brasil - Selic"}]', 200)
        );

        expect(await datasource.getBanks(), isA<List<BankModel>>());
      });

      test('should return a null value if the endpoint returns an invalid response', ()async{
          when(
            client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1")),
          ).thenAnswer((_) async => http.Response("[]", 400));

          expect(await datasource.getBanks(), null);

          when(
            client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1")),
          ).thenAnswer((_) async => http.Response("not found", 404));

          expect(await datasource.getBanks(), null);

          
          when(
            client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1")),
          ).thenAnswer((_) async => http.Response("internal server error", 500));

          expect(await datasource.getBanks(), null);
      });
    });

}