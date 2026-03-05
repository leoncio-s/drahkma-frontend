import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object?> get props => [];
}

class AppInitialState extends AppState
{
  const AppInitialState();
}

class HasNetworkState extends AppState
{
  const HasNetworkState();
}

class Unauthenticated extends AppState{
  const Unauthenticated();
}

class NoNetworkState extends AppState
{
  const NoNetworkState();
}

class TimeoutConnectState extends AppState
{
  final String? message;
  const TimeoutConnectState({this.message});
  @override
  List<String?> get props => [message];
}

class ErrorState extends AppState
{
  final String? message;
  const ErrorState({this.message});
  @override
  List<String?> get props => [message];
}