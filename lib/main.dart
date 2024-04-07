import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/config/theme/app_themes.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/pages/login_page.dart';
import 'package:ku_noti/injection_container.dart';

import 'firebase_options.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // FireBase
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => sl<AuthBloc>()
          ),
          BlocProvider<EventsBloc>(
              create: (context) => sl<EventsBloc>()
          ),
          BlocProvider<FollowEventBloc>(
              create: (context) => sl<FollowEventBloc>()
          ),
          BlocProvider<UserEventBloc>(
              create: (context) => sl<UserEventBloc>()
          )
        ],
        child: MaterialApp(
          theme: theme(),
          home: LoginPage(),
        )
    );
  }
}

