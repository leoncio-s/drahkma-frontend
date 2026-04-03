import 'package:drahkma/core/data/repositories/app_respository_impl.dart';
import 'package:drahkma/core/data/sources/app_check_network_datasource.dart';
import 'package:drahkma/core/data/sources/app_web_check_network_datasource_impl.dart';
import 'package:drahkma/core/data/sources/app_windows_check_network_datasource_impl.dart';
import 'package:drahkma/core/domain/repositories/app_repository.dart';
import 'package:drahkma/core/domain/usecases/check_network_use_case.dart';
import 'package:drahkma/core/presentation/controllers/app_controller.dart';
import 'package:drahkma/features/amount/data/datasources/remote/amount_remote_datasource.dart';
import 'package:drahkma/features/amount/data/datasources/remote/amount_remote_datasource_impl.dart';
import 'package:drahkma/features/amount/data/repositories/amount_repository_impl.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';
import 'package:drahkma/features/amount/domain/usecases/amount_fetchdata.dart';
import 'package:drahkma/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource_impl.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource_impl.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_check_use_case.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_get_saved_email_use_case.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_use_case.dart';
import 'package:drahkma/features/auth/domain/usecases/logout_use_case.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_controller.dart';
import 'package:drahkma/features/bank_account/data/repositories/bank_accounts_repository_impl.dart';
import 'package:drahkma/features/bank_account/data/sources/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/bank_account_remote_datasource_impl.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_bank.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_delete.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_get_all.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_save.dart';
import 'package:drahkma/features/bank_account/domain/usecases/bank_account_update.dart';
import 'package:drahkma/features/card/data/repositories/card_repository_impl.dart';
import 'package:drahkma/features/card/data/sources/card_remote_datasource.dart';
import 'package:drahkma/features/card/data/sources/card_remote_datasource_impl.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';
import 'package:drahkma/features/card/domain/usecases/card_delete.dart';
import 'package:drahkma/features/card/domain/usecases/card_get_all.dart';
import 'package:drahkma/features/card/domain/usecases/card_save.dart';
import 'package:drahkma/features/card/domain/usecases/card_update.dart';
import 'package:drahkma/features/category/data/repositories/category_repository_impl.dart';
import 'package:drahkma/features/category/data/sources/category_remote_datasource.dart';
import 'package:drahkma/features/category/data/sources/category_remote_datasource_impl.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';
import 'package:drahkma/features/category/domain/usecases/category_delete.dart';
import 'package:drahkma/features/category/domain/usecases/category_get_all.dart';
import 'package:drahkma/features/category/domain/usecases/category_get_all_by_user.dart';
import 'package:drahkma/features/category/domain/usecases/category_save.dart';
import 'package:drahkma/features/category/domain/usecases/category_update.dart';
import 'package:drahkma/features/item/data/repositories/item_repository_impl.dart';
import 'package:drahkma/features/item/data/sources/item_remote_datasource.dart';
import 'package:drahkma/features/item/data/sources/item_remote_datasource_impl.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';
import 'package:drahkma/features/item/domain/usecases/item_delete.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_expense.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_income.dart';
import 'package:drahkma/features/item/domain/usecases/item_save.dart';
import 'package:drahkma/features/item/domain/usecases/item_update.dart';
import 'package:drahkma/features/user/data/repositories/user_repository_impl.dart';
import 'package:drahkma/features/user/data/sources/user_remote_datasource.dart';
import 'package:drahkma/features/user/data/sources/user_remote_datasource_impl.dart';
import 'package:drahkma/features/user/domain/repositories/user_repository.dart';
import 'package:drahkma/features/user/domain/usecases/user_profile.dart';
import 'package:drahkma/features/user/domain/usecases/user_register.dart';
import 'package:drahkma/features/user/domain/usecases/user_update.dart';
import 'package:drahkma/features/user/domain/usecases/user_update_password.dart';
import 'package:drahkma/features/user/presentation/controllers/create_user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

void initializeDependencies()
{
  getIt.registerFactory<SharedPreferencesAsync>(()=>SharedPreferencesAsync());
  
  ///// App
  getIt.registerSingleton<AppCheckNetworkDatasource>(kIsWeb ? AppWebCheckNetworkDatasourceImpl() : AppWindowsCheckNetworkDatasourceImpl());
  getIt.registerSingleton<AppRepository>(AppRespositoryImpl(getIt()));
  getIt.registerSingleton<CheckNetworkUseCase>(CheckNetworkUseCase(getIt()));
  getIt.registerSingleton<AppController>(AppController(getIt()));

  //// Auth
  getIt.registerFactory<AuthLocalDatasource>(()=>AuthLocalDatasourceImpl(storage: getIt<SharedPreferencesAsync>()));
  getIt.registerFactory<AuthRemoteDatasource>(()=>AuthRemoteDatasourceImpl());
  getIt.registerFactory<AuthRepository>(()=>AuthRepositoryImpl(getIt<AuthLocalDatasource>(), getIt<AuthRemoteDatasource>()));
  getIt.registerSingleton<AuthUseCase>(AuthUseCase(getIt()));
  getIt.registerSingleton<AuthGetSavedEmailUseCase>(AuthGetSavedEmailUseCase(getIt()));
  getIt.registerSingleton<AuthCheckUseCase>(AuthCheckUseCase(getIt()));
  getIt.registerSingleton<AuthController>(AuthController(getIt(), getIt()));

  //// User
  getIt.registerFactory<UserRemoteDatasource>(()=>UserRemoteDatasourceImpl(getIt<AuthLocalDatasource>()));
  getIt.registerFactory<UserRepository>(() =>UserRepositoryImpl(getIt<UserRemoteDatasource>()));
  getIt.registerFactory<UserUpdate>(()=>UserUpdate(getIt<UserRepository>()));
  getIt.registerFactory<UserRegister>(()=>UserRegister(getIt<UserRepository>()));
  getIt.registerFactory<UserProfile>(()=>UserProfile(getIt<UserRepository>()));
  getIt.registerFactory<LogoutUseCase>(()=>LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<UserUpdatePassword>(()=>UserUpdatePassword(getIt<UserRepository>()));
  getIt.registerFactory<CreateUserController>(()=>CreateUserController());

  ///// Amounts
  getIt.registerFactory<AmountRemoteDatasource>(()=>AmountRemoteDatasourceImpl());
  getIt.registerFactory<AmountRepository>(()=>AmountRepositoryImpl(getIt<AmountRemoteDatasource>()));
  getIt.registerFactory<AmountsFetchdata>(() => AmountsFetchdata(getIt<AmountRepository>()));

  //// BankAccounts
  getIt.registerFactory<BankAccountRemoteDatasource>(()=>BankAccountRemoteDatasourceImpl());
  getIt.registerFactory<BankAccountRepository>(()=>BankAccountRepositoryImpl(getIt<BankAccountRemoteDatasource>()));
  getIt.registerFactory<BankAccountSave>(()=>BankAccountSave(getIt<BankAccountRepository>()));
  getIt.registerFactory<BankAccountUpdate>(()=>BankAccountUpdate(getIt<BankAccountRepository>()));
  getIt.registerFactory<BankAccountDelete>(()=>BankAccountDelete(getIt<BankAccountRepository>()));
  getIt.registerFactory<BankAccountGetAll>(()=>BankAccountGetAll(getIt<BankAccountRepository>()));
  getIt.registerFactory<BankAccountBank>(()=>BankAccountBank(getIt<BankAccountRepository>()));

  //// Cards
  getIt.registerFactory<CardRemoteDatasource>(()=>CardRemoteDatasourceImpl());
  getIt.registerFactory<CardRepository>(()=>CardRepositoryImpl(getIt<CardRemoteDatasource>()));
  getIt.registerFactory<CardSave>(()=>CardSave(getIt<CardRepository>()));
  getIt.registerFactory<CardUpdate>(()=>CardUpdate(getIt<CardRepository>()));
  getIt.registerFactory<CardDelete>(()=>CardDelete(getIt<CardRepository>()));
  getIt.registerFactory<CardGetAll>(()=>CardGetAll(getIt<CardRepository>()));

  //// Category
  getIt.registerFactory<CategoryRemoteDatasource>(()=>CategoryRemoteDatasourceImpl());
  getIt.registerFactory<CategoryRepository>(()=>CategoryRepositoryImpl(getIt<CategoryRemoteDatasource>()));
  getIt.registerFactory<CategorySave>(()=>CategorySave(getIt<CategoryRepository>()));
  getIt.registerFactory<CategoryUpdate>(()=>CategoryUpdate(getIt<CategoryRepository>()));
  getIt.registerFactory<CategoryDelete>(()=>CategoryDelete(getIt<CategoryRepository>()));
  getIt.registerFactory<CategoryGetAll>(()=>CategoryGetAll(getIt<CategoryRepository>()));
  getIt.registerFactory<CategoryGetAllByUser>(()=>CategoryGetAllByUser(getIt<CategoryRepository>()));

  //// Item
  getIt.registerFactory<ItemRemoteDatasource>(()=>ItemRemoteDatasourceImpl());
  getIt.registerFactory<ItemRepository>(()=>ItemRepositoryImpl(getIt<ItemRemoteDatasource>()));
  getIt.registerFactory<ItemSave>(()=>ItemSave(getIt<ItemRepository>()));
  getIt.registerFactory<ItemUpdate>(()=>ItemUpdate(getIt<ItemRepository>()));
  getIt.registerFactory<ItemDelete>(()=>ItemDelete(getIt<ItemRepository>()));
  getIt.registerFactory<ItemGetIncome>(()=>ItemGetIncome(getIt<ItemRepository>()));
  getIt.registerFactory<ItemGetExpense>(()=>ItemGetExpense(getIt<ItemRepository>()));
}