
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ku_noti/features/data/event/repositories/event_repository_impl.dart';
import 'package:ku_noti/features/data/event/service/event_api_service.dart';
import 'package:ku_noti/features/data/user/repositories/user_repository_impl.dart';
import 'package:ku_noti/features/data/user/service/user_service.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart';
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/remote_event_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // FireBase

  // Dependencies
  sl.registerSingleton<UserService>(UserService(sl()));
  sl.registerSingleton<EventApiService>(EventApiService(sl()));

  sl.registerSingleton<UserRepository>(
      UserRepositoryImpl(sl())
  );
  
  sl.registerSingleton<EventRepository>(
    EventRepositoryImpl(sl())
  );

  // UseCase
  sl.registerSingleton<RegisterUserUseCase>(
      RegisterUserUseCase(sl())
  );

  sl.registerSingleton<LoginUserUseCase>(
      LoginUserUseCase(sl())
  );
  
  sl.registerSingleton<GetEventsUseCase>(
    GetEventsUseCase(sl())
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl(), sl())
  );
  
  sl.registerFactory<RemoteEventsBloc>(
      () => RemoteEventsBloc(sl())
  );
}