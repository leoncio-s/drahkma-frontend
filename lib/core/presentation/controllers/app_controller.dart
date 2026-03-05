import 'package:drahkma/core/domain/usecases/check_network_use_case.dart';
// import 'package:drahkma/core/navigation/app_routes.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:flutter/material.dart';

class AppController extends ValueNotifier<AppState>
{
  final CheckNetworkUseCase _useCase;
  AppController(this._useCase) : super(AppInitialState());

  Future<void>  checkNetwork() async
  {
    bool? result = await _useCase.call();
    if(result!)
    {
      value = HasNetworkState();
    }else
    {
      value = NoNetworkState();
    }
  }
  
}