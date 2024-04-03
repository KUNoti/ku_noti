import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/data/user/models/login_request.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';


class LoginUserUseCase implements UseCase<DataState<UserEntity>, LoginRequest> {
  final UserRepository _userRepository;
  LoginUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call({LoginRequest? params}) {
    if (params != null) {
      return _userRepository.login(params);
    }

    return Future(() => DataFailed(
      DioException(
        requestOptions:  RequestOptions(
          data: "login params is null"
        )
      )
    ));
  }

}