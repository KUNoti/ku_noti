import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int ? userId;
  final String ? username;
  final String ? password;
  final String ? name;
  final String ? email;
  final String ? imagePath;
  final File ? imageFile;
  final String? token;

  const UserEntity({
    this.userId,
    this.username,
    this.password,
    this.name,
    this.email,
    this.imagePath,
    this.imageFile,
    this.token
  });

  @override
  List<Object?> get props {
    return [
      userId,
      username,
      password,
      name,
      email,
      imagePath,
      imageFile,
      token
    ];
  }
}

