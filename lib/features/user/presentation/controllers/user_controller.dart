import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/user/domain/usecases/user_profile.dart';
import 'package:drahkma/features/user/domain/usecases/user_register.dart';
import 'package:drahkma/features/user/domain/usecases/user_update.dart';
import 'package:drahkma/features/user/domain/usecases/user_update_password.dart';
import 'package:flutter/material.dart';

class UserController extends ValueNotifier<AppState> {
  final UserProfile _userProfile;
  final UserRegister _userRegister;
  final UserUpdate _userUpdate;
  final UserUpdatePassword _userUpdatePassword;

  UserController(
    this._userProfile,
    this._userRegister,
    this._userUpdate,
    this._userUpdatePassword,
  ) : super(AppInitial());

  Future<void> loadProfile() async {
    value = AppLoading();
    try {
      var result = await _userProfile.call();
      value = AppSuccess(message: 'Profile carregado');
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> registerUser(dynamic user) async {
    value = AppLoading();
    try {
      var result = await _userRegister.call(user: user);
      value = AppSuccess(message: 'Usuário registrado com sucesso');
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> updateUser(dynamic user) async {
    value = AppLoading();
    try {
      var result = await _userUpdate.call(user: user);
      value = AppSuccess(message: 'Usuário atualizado');
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    value = AppLoading();
    try {
      await _userUpdatePassword.call();
      value = AppSuccess(message: 'Senha atualizada');
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class AppInitial extends AppState {}
class AppLoading extends AppState {}
class AppSuccess extends AppState {
  final String message;
  AppSuccess({required this.message});
}
