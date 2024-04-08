
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ku_noti/features/data/event/repositories/event_repository_impl.dart';
import 'package:ku_noti/features/data/event/service/event_api_service.dart';
import 'package:ku_noti/features/data/notification/service/firebase_service.dart';
import 'package:ku_noti/features/data/user/repositories/user_repository_impl.dart';
import 'package:ku_noti/features/data/user/service/user_service.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';
import 'package:ku_noti/features/domain/event/usecases/create_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_tag_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_create_by_me_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_register_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_tag_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_tag_usecase.dart';
import 'package:ku_noti/features/domain/user/repositories/user_repository.dart';
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart';
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // FireBase
  // sl.registerSingleton<FirebaseService>(FirebaseService());

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

  sl.registerSingleton<CreateEventUseCase>(
    CreateEventUseCase(sl())
  );

  sl.registerSingleton<FollowEventUseCase>(
    FollowEventUseCase(sl())
  );

  sl.registerSingleton<UnFollowEventUseCase>(
    UnFollowEventUseCase(sl())
  );
  
  sl.registerSingleton<GetFollowEventUseCase>(
    GetFollowEventUseCase(sl())
  );

  sl.registerSingleton<GetCreateByMeUseCase>(
      GetCreateByMeUseCase(sl())
  );

  sl.registerSingleton<GetTagUseCase>(
      GetTagUseCase(sl())
  );

  sl.registerSingleton<FollowTagUseCase>(
      FollowTagUseCase(sl())
  );

  sl.registerSingleton<UnFollowTagUseCase>(
      UnFollowTagUseCase(sl())
  );

  sl.registerSingleton<GetRegisterEventUseCase>(
      GetRegisterEventUseCase(sl())
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl(), sl())
  );
  
  sl.registerFactory<EventsBloc>(
      () => EventsBloc(sl(), sl())
  );

  sl.registerFactory<FollowEventBloc>(
      () => FollowEventBloc(sl(), sl(), sl())
  );

  sl.registerFactory<UserEventBloc>(
      () => UserEventBloc(sl(), sl(), sl(), sl(),sl())
  );
}