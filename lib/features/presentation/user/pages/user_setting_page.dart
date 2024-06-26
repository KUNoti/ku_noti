import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_event.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';
import 'package:ku_noti/features/presentation/user/pages/login_page.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  void _logOut(BuildContext context) {

    context.read<AuthBloc>().add(const LogOutEvent());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthDone && state.user != null) {
              UserEntity? user = state.user;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        user != null ? Column(
                          children: [
                            _buildImage(user.imagePath),
                            const SizedBox(height: 16),
                            _buildSetting(context, user),
                          ],
                        )
                            : const Placeholder()
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildImage(String? userImage) {
    return Image.network(
      fit: BoxFit.cover,
      userImage ?? 'https://via.placeholder.com/150', // Placeholder image URL
      height: 150,
      width: 150,
    );
  }

  Widget _buildSetting(BuildContext context, UserEntity? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Username'),
          subtitle: Text(user?.username ?? "Username"),
          onTap: () {
            // Handle onTap action
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(user?.email ?? "Email"),
          onTap: () {
            // Handle onTap action
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Name'),
          subtitle: Text(user?.name ?? "Name"),
          onTap: () {
            // Handle onTap action
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          onTap: () {
            // Handle onTap action
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            _logOut(context);
          },
        ),
      ],
    );
  }
}
