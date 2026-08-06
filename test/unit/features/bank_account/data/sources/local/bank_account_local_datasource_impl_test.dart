
import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
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

  group("Saving function", (){
    test("should save bank accounts to local storage", ()async{

      final bank = [BankAccount(id: 1, bankName: "Itau", agency: "1234", bankCode: "341", accountNumber: "1234567")];
      List dtoList = bank.map((el)=>BankAccountMapper.fromEntityToDTO(el).toMap()).toList();
      when(
        storaged.setString(Config.keyStorageBankAccounts, JsonEncoder().convert(dtoList))
      ).thenAnswer((_)async{});

      await expectLater(localDatasource.saveBankAccounts(bank), completes);


      verify(storaged.setString(Config.keyStorageBankAccounts, JsonEncoder().convert(dtoList))).called(1);
    });
  });
}