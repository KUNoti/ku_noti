
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/user/models/user.dart';
import 'package:ku_noti/features/data/user/models/login_request.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';

abstract class UserRepository {
  Future<DataState<void>> register(UserModel user);
  Future<DataState<UserEntity>> login(LoginRequest request);
}