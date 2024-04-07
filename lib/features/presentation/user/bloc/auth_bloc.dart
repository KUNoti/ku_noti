


import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart';
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase _loginUserUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  // final FirebaseApi _firebaseApi;

  AuthBloc(this._loginUserUseCase, this._registerUserUseCase) : super(const AuthInit()) {
    on <LoginEvents> (_onLoginEvents);
    on <RegisterEvent> (_onRegisterEvents);
    on <LogOutEvent> (_onLogOutEvent);
  }

  void _onLoginEvents(LoginEvents event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final dataState = await _loginUserUseCase(params: event.toLoginRequest());
      if (dataState is DataSuccess) {
        print(dataState.data!.toString());
        emit(
            AuthDone(dataState.data!)
        );
      } else if (dataState is DataFailed) {
        emit(
            AuthError(dataState.error!)
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("failed to login $e");
      }
    }
  }

  void _onRegisterEvents(RegisterEvent event, Emitter<AuthState> emit) async {
    // emit(const AuthLoading());
    try {
      // event.userModel.token = _firebaseApi.token;
      final dataState = await _registerUserUseCase(params: event.userModel);

      if (dataState is DataSuccess) {
        emit(
            const RegisterDone()
        );
      } else if (dataState is DataFailed) {
        emit(
            AuthError(dataState.error!)
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("failed to register $e");
      }
    }
  }

  void _onLogOutEvent(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(
        const AuthDone(null)
    );
  }
}