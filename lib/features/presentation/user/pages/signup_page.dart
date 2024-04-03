import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ku_noti/features/data/user/models/user.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_event.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';
import 'package:ku_noti/features/presentation/user/widgets/custom_button.dart';
import 'package:ku_noti/features/presentation/user/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  File? _image;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  void register(BuildContext context) async {
    BlocProvider.of<AuthBloc>(context).add(RegisterEvent(
        UserModel(
            username: usernameController.text,
            password: passwordController.text,
            name: nameController.text,
            email: emailController.text,
            imageFile: _image
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is RegisterDone) {
                    Navigator.pop(context);
                  }

                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error to signup'),
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageView(context),
                      const SizedBox(height: 25),
                      _buildForm(context),
                      const SizedBox(height: 25),
                      // buildbutton
                      _buildButton(context)
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildImageView(BuildContext context) {
    return SizedBox(
        child: _image != null
            ? Image.file(_image!,
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        )
            : Stack(
          children: [
            GestureDetector(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black87,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 150,
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.green,
              ),
            ),
          ],
        )
    );
  }

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
      }) async {
    // Map<Permission, PermissionStatus> status = await [
    //   Permission.camera,
    //   Permission.storage,
    // ].request();
    //
    // if (status[Permission.camera] != PermissionStatus.granted ||
    //     status[Permission.camera] != PermissionStatus.granted) {
    //   return;
    // }

    _pickedFile = await _picker.pickImage(source: source);
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      });
    }
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: usernameController,
              icon: Icons.text_fields,
              hintText: "Username",
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
              hintText: "Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: nameController,
              icon: Icons.text_format,
              hintText: "Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Name';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: emailController,
              icon: Icons.email,
              hintText: "Email",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Email';
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
      buttonText: 'Sign Up',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Signup')),
          );
          register(context);
        }
      },
    );
  }
}
