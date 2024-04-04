import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_event.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';
import 'package:ku_noti/features/presentation/user/pages/signup_page.dart';
import 'package:ku_noti/features/presentation/user/widgets/custom_button.dart';
import 'package:ku_noti/features/presentation/user/widgets/custom_textfield.dart';
import 'package:ku_noti/navigation/main_screen.dart';
import 'package:ku_noti/navigation/nav_bar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // sign user in method
  void signUserIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(LoginEvents(
      usernameController.text,
      passwordController.text,
    ));
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthDone) {
                      print("user ${state.user}");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen(),
                      ));
                    }

                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error for login'),
                        ),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Icon(
                          Icons.android,
                          size: 100,
                        ),
                        const SizedBox(height: 50),
                        _buildForm(),
                        const SizedBox(height: 25),
                        _buildButton(context),
                        const SizedBox(height: 25),
                        _buildRegisterSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: usernameController,
              icon: Icons.android,
              hintText: 'Username',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Username';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: passwordController,
              icon: Icons.lock,
              hintText: 'Password',
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return CustomButton(
      buttonText: 'Sign In',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Login')),
          );
          signUserIn(context);
        }
      },
      backColor: Colors.deepPurpleAccent,
      foreColor: Colors.white,
    );
  }

  Widget _buildRegisterSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),
        // not a member? register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Not a member?',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => navigateToRegisterPage(context),
              child: const Text(
                'Register now',
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
