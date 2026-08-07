
import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/data/sources/local/bank_account_local_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/local/bank_account_local_datasource_impl.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bank_account_local_datasource_impl_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<SharedPreferencesAsync>(as: #MockSharedPreferencesAsync)])
void main(){
  final storaged = MockSharedPreferencesAsync();
  final BankAccountLocalDatasource localDatasource = BankAccountLocalDatasourceImpl(storage: storaged);

  // ---- saving banks
  group("Saving bank accounts from local storage", (){
    test("should save bank accounts to local storage", ()async{

      final bank = [BankAccount(id: 1, bankName: "Itau", agency: "1234", bankCode: "341", accountNumber: "1234567")];
      List dtoList = bank.map((el)=>BankAccountMapper.fromEntityToDTO(el).toMap()).toList();
      when(
        storaged.setString(Config.keyStorageBankAccounts, JsonEncoder().convert(dtoList))
      ).thenAnswer((_)async{});

      await expectLater(localDatasource.saveBankAccounts(bank), completes);


      verify(storaged.setString(Config.keyStorageBankAccounts, JsonEncoder().convert(dtoList))).called(1);
    });

    test("should throw a Storage Exception when saving bank accounts to local storage", ()async{

      when(
        storaged.setString(any, any)
      ).thenThrow(Exception());

      final bank = [BankAccount(id: 1, bankName: "Itau", agency: "1234", bankCode: "341", accountNumber: "1234567")];
      await expectLater(localDatasource.saveBankAccounts(bank), throwsA(isA<Exception>()));

      verify(storaged.setString(any, any)).called(1);
    });
  });


  /// ---- get banks
  group("Get Bank Accounts from local storage", (){
    test("should return bank accounts from local storage", ()async{
      BankAccountDTO dto = BankAccountDTO(id: 1, bankName: "Itau", agency: "1234", bankCode: "341", accountNumber: "1234567");
      when(
        storaged.getString(Config.keyStorageBankAccounts)
      ).thenAnswer((_)async => JsonEncoder().convert([dto.toMap()]));
      
      var ret = await localDatasource.getBankAccounts();
      expect(ret, isA<List<BankAccount>>().having((data)=>data.length, "Count items", equals(1)));

      verify(storaged.getString(any)).called(1);
    });

    test("should return empty list from local storage", ()async{
      when(
        storaged.getString(Config.keyStorageBankAccounts)
      ).thenAnswer((_)async => null);
      
      var ret = await localDatasource.getBankAccounts();
      expect(ret, isA<List>().having((data)=>data.length, "Count items", equals(0)));

      verify(storaged.getString(any)).called(1);
    });

    test("should throw Storage Exception from local storage", ()async{
      when(
        storaged.getString(any)
      ).thenThrow(Exception());
      
      await expectLater(localDatasource.getBankAccounts(), throwsA(isA<Exception>()));

      verify(storaged.getString(any)).called(1);
    });
  });

  group("Clear Bank Accounts from local storage", (){
    test("should complete successfully", ()async{
      when(storaged.remove(Config.keyStorageBankAccounts)).thenAnswer((_)async{});

      await expectLater(localDatasource.clearBankAccounts(), completes);

      verify(storaged.remove(Config.keyStorageBankAccounts)).called(1);
    });

    test("should throws Storage Exception", ()async{
      when(storaged.remove(any)).thenThrow(Exception());

      await expectLater(localDatasource.clearBankAccounts(), throwsA(isA<Exception>()));

      verify(storaged.remove(any)).called(1);
    });
  });
}