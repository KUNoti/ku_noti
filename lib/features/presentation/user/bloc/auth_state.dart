import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';

abstract class AuthState extends Equatable {
  final UserEntity ? user;
  final DioException ? exception;
  const AuthState({this.user, this.exception});

  @override
  List<Object> get props => [user!, exception!];
}

class AuthInit extends AuthState {
  const AuthInit();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthDone extends AuthState {
  const AuthDone(UserEntity userEntity): super(user: userEntity);
}

class AuthError extends AuthState {
  const AuthError(DioException exception) : super(exception: exception);
}

class RegisterDone extends AuthState {
  const RegisterDone();
}