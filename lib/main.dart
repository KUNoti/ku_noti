import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/config/theme/app_themes.dart';
import 'package:ku_noti/features/data/notification/local/norification_service.dart';
import 'package:ku_noti/features/data/notification/service/firebase_service.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/pages/login_page.dart';
import 'package:ku_noti/injection_container.dart';
import 'package:timezone/data/latest.dart' as tz;


import 'firebase_options.dart';
import 'global_keys.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // FireBase
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  // if (Platform.isAndroid) {
  //   await FirebaseService().initNotifications();
  // }

  NotificationService().initNotification();
  tz.initializeTimeZones();
  // NotificationHelper.init();
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: LoginPage(),
        )
    );
  }
}

