import 'package:drahkma/core/domain/entities/failure.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

sealed class AuthState extends AppState
{
  const AuthState();
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