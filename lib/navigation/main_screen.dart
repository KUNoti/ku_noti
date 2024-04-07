
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_event.dart';
import 'package:ku_noti/features/presentation/event/pages/explore_event_page.dart';
import 'package:ku_noti/features/presentation/event/pages/favorites_page.dart';

import 'package:ku_noti/features/presentation/event/pages/home_page.dart';
import 'package:ku_noti/features/presentation/event/pages/my_event_page.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';
import 'package:ku_noti/features/presentation/user/pages/login_page.dart';
import 'package:ku_noti/features/presentation/user/pages/user_setting_page.dart';
import 'package:ku_noti/navigation/nav_bar.dart';
import 'package:ku_noti/navigation/nav_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final exploreNavKey = GlobalKey<NavigatorState>();
  final favoritesNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  final myEventNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];


  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthBloc>().state.user?.userId;
    BlocProvider.of<EventsBloc>(context).add(const GetEvents());
    BlocProvider.of<FollowEventBloc>(context).add(LoadFollowedEvents(userId));
    items = [
      NavModel(
        page: const HomePage(),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const ExplorePage(),
        navKey: exploreNavKey,
      ),
      NavModel(
        page: const FavoritesPage(),
        navKey: favoritesNavKey,
      ),
      NavModel(
        page: const MyEventPage(),
        navKey: myEventNavKey,
      ),
      NavModel(
        page: const UserSettingsPage(),
        navKey: profileNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Check the state and react accordingly
        if (state is AuthDone && state.user == null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: selectedTab,
              children: items.map((item) => Navigator(
                key: item.navKey,
                onGenerateInitialRoutes: (navigator, initialRoute) {
                  return [MaterialPageRoute(builder: (context) => item.page)];
                },
              )).toList(),
            ),
            bottomNavigationBar: state.user != null ? NavBar(
              pageIndex: selectedTab,
              onTap: (index) {
                setState(() {
                  if (index == selectedTab) {
                    items[index].navKey.currentState?.popUntil((route) => route.isFirst);
                  } else {
                    selectedTab = index;
                  }
                });
              },
            ) : null,
          );
        },
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Tab $tab')),
      body: Center(child: Text('Tab $tab')),
    );
  }
}