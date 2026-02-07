import 'package:drahkma/core/domain/entities/failure.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable
{
  const AuthState();
  @override
  List<Object?> get props => [];

}

class AuthInitial extends AuthState{
  const AuthInitial();
}
class AuthLoading extends AuthState{
  const AuthLoading();
}
class AuthFailure extends AuthState{
  final List<Failure>? error;
  const AuthFailure({this.error});

  @override
  List<Failure> get props => error!;
}
class AuthSuccess extends AuthState{
  final User? user;
  const AuthSuccess({this.user});

  @override
  List<User?> get props => [user];
}
class Unauthenticated extends AuthState{
  const Unauthenticated();
}