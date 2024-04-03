
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ku_noti/features/data/user/repositories/user_repository_impl.dart';
import 'package:ku_noti/features/data/user/service/user_service.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart';
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // FireBase

  // Dependencies
  sl.registerSingleton<UserService>(UserService(sl()));

  sl.registerSingleton<UserRepository>(
      UserRepositoryImpl(sl())
  );

  // UseCase
  sl.registerSingleton<RegisterUserUseCase>(
      RegisterUserUseCase(sl())
  );

  sl.registerSingleton<LoginUserUseCase>(
      LoginUserUseCase(sl())
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl(), sl())
  );
}