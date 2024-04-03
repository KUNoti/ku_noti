import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/data/user/models/user.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';


class RegisterUserUseCase implements UseCase<DataState<void>, UserModel> {
  final UserRepository _userReposity;
  RegisterUserUseCase(this._userReposity);

  @override
  Future<DataState<void>> call({UserModel? params}) {
    if (params != null) {
      return _userReposity.register(params);
    }

    return Future(() => DataFailed(
        DioException(
            requestOptions: RequestOptions(
                data: "user params is null"
            )
        )
    ));
  }
}