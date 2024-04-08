
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ku_noti/features/data/notification/local/norification_service.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_event.dart';
import 'package:ku_noti/features/presentation/event/pages/explore_event_page.dart';
import 'package:ku_noti/features/presentation/event/pages/favorites_page.dart';

import 'package:ku_noti/features/presentation/event/pages/home_page.dart';
import 'package:ku_noti/features/presentation/event/pages/my_event_page.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/pages/user_setting_page.dart';
import 'package:ku_noti/navigation/nav_bar.dart';
import 'package:ku_noti/navigation/nav_model.dart';
import 'package:timezone/data/latest.dart' as tz;

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
    tz.initializeTimeZones();
    final user = context.read<AuthBloc>().state.user;
    BlocProvider.of<EventsBloc>(context).add(const GetEvents());
    BlocProvider.of<FollowEventBloc>(context).add(LoadFollowedEvents(user?.userId));
    BlocProvider.of<UserEventBloc>(context).add(LoadTag(user?.token));
    BlocProvider.of<UserEventBloc>(context).add(LoadUserEventsEvent(user?.userId));
    // BlocProvider.of<UserEventBloc>(context).add(LoadUserRegisterEvent(user?.userId));
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
        page: const NotiPage(),
        navKey: profileNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar:  NavBar(
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
      ),
    );
  }
}

DateTime scheduleTime = DateTime.now();

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DatePickerTxt(),
            ScheduleBtn(),
          ],
        ),
      ),
    );
  }
}


class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    super.key,
  });

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}
