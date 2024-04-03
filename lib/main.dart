import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/features/presentation/event/pages/home_page.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/pages/login_page.dart';
import 'package:ku_noti/injection_container.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
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
          )
        ],
        child: MaterialApp(
          home: LoginPage(),
        )
    );
  }
}

