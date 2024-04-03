import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/user/models/user.dart';
import 'package:ku_noti/features/data/user/models/login_request.dart';
import 'package:ku_noti/features/data/user/service/user_service.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';


class UserRepositoryImpl implements UserRepository {
  final UserService _userService;
  UserRepositoryImpl(this._userService);

  @override
  Future<DataState<UserModel>> login(LoginRequest request) async {
    try {
      final httpResponse = await _userService.login(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> register(UserModel user) async{
    try {
      final httpResponse = await _userService.register(
          user.username! ,
          user.password!,
          user.name!,
          user.email!,
          user.imageFile!,
          user.token!
      );
      if(httpResponse.response.statusCode == HttpStatus.created) {
        return const DataSuccess<void>(null);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }
}