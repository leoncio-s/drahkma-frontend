import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/data/models/unprocessable_entity_model.dart';
import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/core/error/unprocessable_entity_exception.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/data/models/bank_model.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource_impl.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'bank_account_datasource_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<AuthLocalDatasource>(as: #MockAuthLocalDatasource)
])
void main() {
  final client = MockHttpClient();
  final BankAccountRemoteDatasource datasource =
      BankAccountRemoteDatasourceImpl(client);
  group('fetchBanks', () {
    test('should return a valid list of banks', () async {
      when(
        client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1")),
      ).thenAnswer((_) async => http.Response(
          '[{"ispb":"00000000","name":"BCO DO BRASIL S.A.","code":1,"fullName":"Banco do Brasil S.A."},{"ispb":"00000208","name":"BRB - BCO DE BRASILIA S.A.","code":70,"fullName":"BRB - BANCO DE BRASILIA S.A."},{"ispb":"00038121","name":"Selic","code":null,"fullName":"Banco Central do Brasil - Selic"}]',
          200));

      expect(await datasource.getBanks(), isA<List<BankModel>>());
    });

    test(
        'should return a null value if the endpoint returns an invalid response',
        () async {
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

  group("BankAccounts", () {
    late MockAuthLocalDatasource authLocal;

    setUp(() async {
      await getIt.reset();
      authLocal = MockAuthLocalDatasource();
      getIt.registerFactory<AuthLocalDatasource>(() => authLocal);

      when(authLocal.getAuthToken())
          .thenAnswer((_) async => UserModel(token: 'token-teste'));
    });
    test("should get a valid list of bank accounts of user", () async {
      when(client.get(Uri.parse("${Config.urlApi}banks"),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(
              jsonEncode([
                {
                  "id": 1,
                  "bankCode": '341',
                  "accountNumber": '1234567-7',
                  "agency": '5432',
                  "bankName": 'Itau'
                },
                {
                  "id": 2,
                  "bankCode": '000',
                  "accountNumber": '743217',
                  "agency": '123',
                  "bankName": 'Banco do Brasil'
                }
              ]),
              200));

      expect(await datasource.getAll(), isA<List<BankAccount>>());
    });
    test("should get a unauthorized status code", () async {
      when(client.get(Uri.parse("${Config.urlApi}banks"),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(
              jsonEncode({"message": "usuário não autenticado"}), 401));

      await expectLater(datasource.getAll(),
          throwsA(isA<InvalidCredentialsException>()));
    });

    test("should get a internal server status", () async {
      when(client.get(Uri.parse("${Config.urlApi}banks"),
              headers: anyNamed("headers")))
          .thenAnswer(
              (_) async => http.Response("erro interno no servidor", 500));

      expect(await datasource.getAll(), equals(List.empty()));
    });

    test("should get a valid response when save a valid object", () async {
      when(client.post(Uri.parse("${Config.urlApi}banks"),
              headers: anyNamed("headers"), body: anyNamed("body")))
          .thenAnswer((_) async {
        return http.Response(
            jsonEncode({
              "id": 1,
              "bankCode": "341",
              "bankName": "Itaú",
              "agency": "543",
              "accountNumber": "345555"
            }),
            201);
      });
      BankAccount data = BankAccount(
          bankName: "Itau",
          agency: "543",
          accountNumber: "345555",
          bankCode: "341");
      var ret = await datasource.save(data);
      expect(ret, isA<BankAccount>());
      expect(ret?.id, equals(1));
    });

    test("should get a unprocessable entity when save a invalid object",
        () async {
      when(client.post(Uri.parse("${Config.urlApi}banks"),
              headers: anyNamed("headers"), body: anyNamed("body")))
          .thenAnswer((_) async {
        Map<String, dynamic> ret = {
          "errors": {
            "accountNumber": ["This field is required"]
          },
          "data": {"bankName": "Itau", "agency": "543", "bankCode": "341"}
        };

        return http.Response(jsonEncode(ret), 422);
      });
      BankAccount data =
          BankAccount(bankName: "Itau", agency: "543", bankCode: "341");

      await expectLater(
          datasource.save(data),
          throwsA(isA<UnprocessableEntityException>()
              .having((exception) => exception.error, "validations errors",
                  isA<UnprocessableEntityModel>())
              .having(
                  (exception) => exception.error?.errors,
                  "Contains accountNumber validation",
                  containsPair("accountNumber", ["This field is required"]))));
    });
  });
}
