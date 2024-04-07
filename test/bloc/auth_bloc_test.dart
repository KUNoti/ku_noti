import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/user/models/login_request.dart';
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ku_noti/features/domain/user/entities/user.dart';
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_event.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([LoginUserUseCase, RegisterUserUseCase])
void main() {
  group('AuthBloc Tests', () {
    late MockLoginUserUseCase mockLoginUserUseCase;
    late MockRegisterUserUseCase mockRegisterUserUseCase;
    late AuthBloc authBloc;

    setUp(() {
      mockLoginUserUseCase = MockLoginUserUseCase();
      mockRegisterUserUseCase = MockRegisterUserUseCase();
      authBloc = AuthBloc(mockLoginUserUseCase, mockRegisterUserUseCase);
    });

    blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthDone] when LoginEvents is added and login is successful',
        build: () => authBloc,
        act: (bloc) {
          when(mockLoginUserUseCase(params: anyNamed('params')))
              .thenAnswer((_) async => const DataSuccess(UserEntity(userId: 1, username: 'test')));
          bloc.add(const LoginEvents('test', 'password'));
        },
        expect: () => [
          const AuthLoading(),
          isA<AuthDone>().having((state) => state.user, 'user', isNotNull),
        ],
        verify: (_) {
          verify(mockLoginUserUseCase(params: anyNamed('params'))).called(1);
        }
    );

    blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when LoginEvents is added and login fails',
        build: () => authBloc,
        act: (bloc) {
          when(mockLoginUserUseCase(params: anyNamed('params')))
              .thenAnswer((_) async => DataFailed(DioException(requestOptions: RequestOptions(path: 'path'))));
          bloc.add(const LoginEvents('wrong','password'));
        },
        expect: () => [
          const AuthLoading(),
          isA<AuthError>(),
        ]
    );

    tearDown(() {
      authBloc.close();
    });
  });
}