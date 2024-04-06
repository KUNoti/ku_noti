
import 'package:ku_noti/features/data/user/models/user.dart';
import 'package:ku_noti/features/data/user/models/login_request.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class LoginEvents extends AuthEvent {
  final String username;
  final String password;
  const LoginEvents(this.username, this.password);
}

extension LoginEventsExtension on LoginEvents {
  LoginRequest toLoginRequest() {
    return LoginRequest(username: username, password: password);
  }
}

class RegisterEvent extends AuthEvent {
  final UserModel userModel;

  const RegisterEvent(
    this.userModel
  );
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}