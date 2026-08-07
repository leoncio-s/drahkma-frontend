import 'dart:io';

import 'package:drahkma/core/data/models/unprocessable_entity_model.dart';
import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/core/error/unprocessable_entity_exception.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/data/repositories/bank_accounts_repository_impl.dart';
import 'package:drahkma/features/bank_account/data/sources/local/bank_account_local_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bank_accounts_repository_impl_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<BankAccountRemoteDatasource>(as: #MockRemoteDataSource),
  MockSpec<BankAccountLocalDatasource>(as: #MockLocalDataSource)
])
void main() {
  MockRemoteDataSource remoteDataSource = MockRemoteDataSource();
  MockLocalDataSource localDataSource = MockLocalDataSource();
  BankAccountRepository repository =
      BankAccountRepositoryImpl(remoteDataSource, localDataSource);

  //// ---- brasilapi banks tests
  ///
  group('fetchBanks', () {
    test('should return a valid list of banks', () async {
      when(
        remoteDataSource.getBanks(),
      ).thenAnswer((_) async => [
            Bank(
                ispb: "00000000",
                name: "BCO DO BRASIL S.A.",
                code: 1,
                fullName: "Banco do Brasil S.A."),
            Bank(
                ispb: "00000208",
                name: "BRB - BCO DE BRASILIA S.A.",
                code: 70,
                fullName: "BRB - BANCO DE BRASILIA S.A."),
            Bank(
                ispb: "00038121",
                name: "Selic",
                code: null,
                fullName: "Banco Central do Brasil - Selic")
          ]);

      expect(await repository.getBanks(), isA<List<Bank>>());

      verify(remoteDataSource.getBanks()).called(1);
    });

    test(
        'should return a null value when the endpoint returns an invalid response',
        () async {
      when(
        remoteDataSource.getBanks(),
      ).thenAnswer((_) async => null);

      expect(await repository.getBanks(), null);

      verify(remoteDataSource.getBanks()).called(1);
    });
  });

  /// --------- get tests
  ///
  group("BankAccounts-get", () {
    test("should return the user's bank accounts", () async {
      when(remoteDataSource.getAll()).thenAnswer((_) async => [
            BankAccountModel.fromJson({
              "id": 1,
              "bankCode": '341',
              "accountNumber": '1234567-7',
              "agency": '5432',
              "bankName": 'Itau'
            }),
            BankAccountModel.fromJson({
              "id": 2,
              "bankCode": '000',
              "accountNumber": '743217',
              "agency": '123',
              "bankName": 'Banco do Brasil'
            })
          ]);

      expect(await repository.getAll(), isA<List<BankAccount>>());

      verify(remoteDataSource.getAll()).called(1);
      verifyNever(localDataSource.getBankAccounts()).called(0);
    });
    test("should throw an unauthorized exception when the server returns 401",
        () async {
      when(remoteDataSource.getBanks())
          .thenThrow(InvalidCredentialsException());

      when(localDataSource.getBankAccounts())
          .thenThrow(InvalidCredentialsException());

      await expectLater(
          repository.getAll(), throwsA(isA<InvalidCredentialsException>()));

      verify(remoteDataSource.getAll()).called(1);
      verify(localDataSource.getBankAccounts()).called(1);
    });

    test(
        "should throw an internal server exception when the server returns 500",
        () async {
      when(remoteDataSource.getAll()).thenAnswer((_) async => []);

      expect(await repository.getAll(), equals(List.empty()));

      verify(remoteDataSource.getAll()).called(1);
      verifyNever(localDataSource.getBankAccounts()).called(0);
    });

    test("should return an empty list when the user has no bank accounts",
        () async {
      when(remoteDataSource.getAll()).thenAnswer((_) async => []);

      expect(
          await repository.getAll(),
          isA<List?>()
              .having((data) => data!.length, "data value count", equals(0)));

      verify(remoteDataSource.getAll()).called(1);
      verifyNever(localDataSource.getBankAccounts()).called(0);
    });
  });

  // -------------- save tests

  group("BankAccounts-Save", () {
    test("should save a valid bank account successfully", () async {
      when(remoteDataSource.save(any))
          .thenAnswer((_) async => BankAccountModel.fromJson({
                "id": 1,
                "bankCode": "341",
                "bankName": "Itaú",
                "agency": "543",
                "accountNumber": "345555"
              }));
      BankAccount data = BankAccount(
          bankName: "Itau",
          agency: "543",
          accountNumber: "345555",
          bankCode: "341");

      var ret = await repository.save(data);
      expect(ret, isA<BankAccount>());
      expect(ret?.id, equals(1));

      verify(remoteDataSource.save(any)).called(1);
      verify(localDataSource.saveBankAccounts(any)).called(1);
    });

    test(
        "should throw an unprocessable entity exception when saving an invalid bank account",
        () async {
      when(remoteDataSource.save(any)).thenThrow(UnprocessableEntityException(
          error: UnprocessableEntityModel({
        "bankName": "Itau",
        "agency": "543",
        "bankCode": "341"
      }, {
        "accountNumber": ["This field is required"]
      })));

      BankAccount data =
          BankAccount(bankName: "Itau", agency: "543", bankCode: "341");

      await expectLater(
          repository.save(data),
          throwsA(isA<UnprocessableEntityException>()
              .having((exception) => exception.error, "validations errors",
                  isA<UnprocessableEntityModel>())
              .having(
                  (exception) => exception.error?.errors,
                  "Contains accountNumber validation",
                  containsPair("accountNumber", ["This field is required"]))));

      verify(remoteDataSource.save(any)).called(1);
      verifyNever(localDataSource.saveBankAccounts(any)).called(0);
    });

    test("should throw an unauthorized exception when saving a bank account",
        () async {
      when(remoteDataSource.save(any))
          .thenThrow(InvalidCredentialsException());
      BankAccount data =
          BankAccount(bankName: "Itau", agency: "543", bankCode: "341");
      await expectLater(
          repository.save(data), throwsA(isA<InvalidCredentialsException>()));

      verify(remoteDataSource.save(any)).called(1);
      verifyNever(localDataSource.saveBankAccounts(any)).called(0);
    });

    test("should throw an internal server exception when saving a bank account",
        () async {
      when(remoteDataSource.save(any))
          .thenThrow(HttpException("internal server error"));
      BankAccount data =
          BankAccount(bankName: "Itau", agency: "543", bankCode: "341");
      await expectLater(repository.save(data), throwsA(isA<HttpException>()));

      verify(remoteDataSource.save(any)).called(1);
      verifyNever(localDataSource.saveBankAccounts(any)).called(0);
    });
  });

  // // -------------- update tests

  // group("BankAccounts-Update", () {
  //   late MockAuthLocalDatasource authLocal;
  //   setUp(() async {
  //     await getIt.reset();
  //     authLocal = MockAuthLocalDatasource();
  //     getIt.registerFactory<AuthLocalDatasource>(() => authLocal);

  //     when(authLocal.getAuthToken())
  //         .thenAnswer((_) async => UserModel(token: 'token-teste'));
  //   });
  //   test("should update a valid bank account successfully", () async {
  //     when(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .thenAnswer((_) async {
  //       return http.Response(
  //           jsonEncode({
  //             "id": 1,
  //             "bankCode": "341",
  //             "bankName": "Itaú",
  //             "agency": "543",
  //             "accountNumber": "345555"
  //           }),
  //           200);
  //     });
  //     BankAccount data = BankAccount(
  //         id: 1,
  //         bankName: "Itau",
  //         agency: "543",
  //         accountNumber: "345555",
  //         bankCode: "341");

  //     await expectLater(datasource.update(data), completes);

  //     verify(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });

  //   test(
  //       "should throw an unprocessable entity exception when updating an invalid bank account",
  //       () async {
  //     when(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .thenAnswer((_) async {
  //       Map<String, dynamic> ret = {
  //         "errors": {
  //           "accountNumber": ["This field is required"],
  //           "id": ["This field is required"]
  //         },
  //         "data": {"bankName": "Itau", "agency": "543", "bankCode": "341"}
  //       };

  //       return http.Response(jsonEncode(ret), 422);
  //     });
  //     BankAccount data =
  //         BankAccount(bankName: "Itau", agency: "543", bankCode: "341");

  //     await expectLater(
  //         datasource.update(data),
  //         throwsA(isA<UnprocessableEntityException>()
  //             .having((exception) => exception.error, "validations errors",
  //                 isA<UnprocessableEntityModel>())
  //             .having(
  //                 (exception) => exception.error?.errors,
  //                 "Contains accountNumber validation",
  //                 containsPair("accountNumber", ["This field is required"]))
  //             .having(
  //                 (exception) => exception.error?.errors,
  //                 "Contains id validation",
  //                 containsPair("id", ["This field is required"]))));

  //     verify(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });

  //   test("should throw an unauthorized exception when updating a bank account",
  //       () async {
  //     when(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .thenAnswer((_) async =>
  //             http.Response(jsonEncode({"message": "Unauthenticated"}), 401));
  //     BankAccount data =
  //         BankAccount(bankName: "Itau", agency: "543", bankCode: "341");
  //     await expectLater(
  //         datasource.update(data), throwsA(isA<InvalidCredentialsException>()));

  //     verify(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });

  //   test(
  //       "should throw an internal server exception when updating a bank account",
  //       () async {
  //     when(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .thenAnswer((_) async => http.Response(
  //             jsonEncode({"message": "erro interno no servidor"}), 500));
  //     BankAccount data =
  //         BankAccount(bankName: "Itau", agency: "543", bankCode: "341");
  //     await expectLater(datasource.update(data), throwsA(isA<HttpException>()));

  //     verify(client.put(Uri.parse("${Config.urlApi}banks"),
  //             headers: anyNamed("headers"), body: anyNamed("body")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });
  // });

  // /// --- delete tests
  // group("BankAccounts-delete", () {
  //   late MockAuthLocalDatasource authLocal;

  //   BankAccount data = BankAccount(
  //       id: 1,
  //       bankCode: '341',
  //       bankName: 'Itau',
  //       agency: '1234',
  //       accountNumber: '123456');

  //   setUp(() async {
  //     await getIt.reset();
  //     authLocal = MockAuthLocalDatasource();
  //     getIt.registerFactory<AuthLocalDatasource>(() => authLocal);

  //     when(authLocal.getAuthToken())
  //         .thenAnswer((_) async => UserModel(token: 'token-teste'));
  //   });

  //   test("should delete a bank account successfully", () async {
  //     when(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .thenAnswer((_) async => http.Response(jsonEncode([]), 200));

  //     await expectLater(datasource.delete(data), isA<void>());

  //     verify(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });

  //   test("should throw an unauthorized exception when deleting a bank account",
  //       () async {
  //     when(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .thenAnswer((_) async =>
  //             http.Response(jsonEncode({"message": "Unauthenticated"}), 401));

  //     await expectLater(
  //         datasource.delete(data), throwsA(isA<InvalidCredentialsException>()));

  //     verify(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });

  //   test(
  //       "should throw an internal server exception when deleting a bank account",
  //       () async {
  //     when(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .thenAnswer((_) async => http.Response(
  //             jsonEncode({"message": "internal server error"}), 500));

  //     await expectLater(
  //         datasource.delete(data),
  //         throwsA(isA<HttpException>().having(
  //             (except) => except.message,
  //             "Message internal server error",
  //             equals('internal server error'))));

  //     verify(client.delete(Uri.parse("${Config.urlApi}banks/${data.id}"),
  //             headers: anyNamed("headers")))
  //         .called(1);
  //     verify(authLocal.getAuthToken()).called(1);
  //   });
  // });
}
