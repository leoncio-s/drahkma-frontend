import 'dart:async';

import 'package:drahkma/core/domain/entities/failure.dart';
import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/core/error/user_not_allowed_exception.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_check_use_case.dart';
import 'package:drahkma/features/auth/domain/usecases/auth_use_case.dart';
import 'package:drahkma/features/auth/presentation/controllers/auth_state.dart';
import 'package:drahkma/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthController extends ValueNotifier<AppState>
{
  final AuthUseCase _useCase;
  final AuthCheckUseCase _authCheckUseCase;
  AuthController(this._useCase, this._authCheckUseCase) : super(AuthInitial());

  Future<void> checkSession() async
  {
    await appController.checkNetwork();
    value = AuthLoading();
    try{
     var result = await _authCheckUseCase.call();
    
      if(result == null)
      {
        value = AuthInitial();
      }else
      {
        value = AuthSuccess();
      } 
    }on ClientException
    {
      value = NoNetworkState();
    }on TimeoutException catch(e)
    {
      value = TimeoutConnectState(message: e.message);
    }catch(e, s)
    {
      debugPrintStack(stackTrace: s, label: "App State Error. AppController");
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> signIn(String email, String password) async
  {
    await appController.checkNetwork();
    value = AuthLoading();
    AuthModel auth = AuthModel(
      login: email,
      password: password
    );

    try{
      final result = await _useCase.call(
        auth: auth
      );
      if (result == null) {
        var failure =  Failure("Erro para realizar login. Tente novamente mais tarde!");
        value = AuthFailure(error: [failure]);
      } else {
        value=AuthSuccess(user: result);
      }
    }on InvalidCredentialsException catch (e)
    {
      value = AuthFailure(error: [Failure(e.message)]);
    }on UserNotAllowedException catch (e)
    {
      value = AuthFailure(error: [Failure(e.message)]);
    }on TimeoutException catch(e)
    {
      value = TimeoutConnectState(message: e.message);
    }on ClientException catch(e)
    {
      value = AppStateError(message: "Erro interno no servidor: ${e.message}");
    }catch(e, s)
    {
      debugPrintStack(stackTrace: s, label: "Call Auth Endpoint");
      value = AppStateError(message: e.toString());
    }
  }
  
}