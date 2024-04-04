import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class FollowEventState extends Equatable{
  final String? errorMessage;

  const FollowEventState({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class FollowEventInitial extends FollowEventState {
  const FollowEventInitial();
}

class FollowEventLoading extends FollowEventState {
  const FollowEventLoading();
}

class FollowEventSuccess extends FollowEventState {
  const FollowEventSuccess();
}

class FollowEventError extends FollowEventState {
  const FollowEventError(String errorMessage) : super(errorMessage: errorMessage);
}

class UnFollowEventSuccess extends FollowEventState {
  const UnFollowEventSuccess();
}

class UnFollowEventError extends FollowEventState {
  const UnFollowEventError(String errorMessage) : super(errorMessage: errorMessage);
}