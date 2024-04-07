// Mocks generated by Mockito 5.4.4 from annotations
// in ku_noti/test/bloc/auth_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:ku_noti/core/resources/data_state.dart' as _i2;
import 'package:ku_noti/features/data/user/models/login_request.dart' as _i6;
import 'package:ku_noti/features/data/user/models/user.dart' as _i8;
import 'package:ku_noti/features/domain/user/entities/user.dart' as _i5;
import 'package:ku_noti/features/domain/user/usecases/login_user_usercase.dart'
    as _i3;
import 'package:ku_noti/features/domain/user/usecases/register_user_usecase.dart'
    as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDataState_0<T> extends _i1.SmartFake implements _i2.DataState<T> {
  _FakeDataState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LoginUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUserUseCase extends _i1.Mock implements _i3.LoginUserUseCase {
  MockLoginUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.DataState<_i5.UserEntity>> call({_i6.LoginRequest? params}) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {#params: params},
        ),
        returnValue: _i4.Future<_i2.DataState<_i5.UserEntity>>.value(
            _FakeDataState_0<_i5.UserEntity>(
          this,
          Invocation.method(
            #call,
            [],
            {#params: params},
          ),
        )),
      ) as _i4.Future<_i2.DataState<_i5.UserEntity>>);
}

/// A class which mocks [RegisterUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegisterUserUseCase extends _i1.Mock
    implements _i7.RegisterUserUseCase {
  MockRegisterUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.DataState<void>> call({_i8.UserModel? params}) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {#params: params},
        ),
        returnValue:
            _i4.Future<_i2.DataState<void>>.value(_FakeDataState_0<void>(
          this,
          Invocation.method(
            #call,
            [],
            {#params: params},
          ),
        )),
      ) as _i4.Future<_i2.DataState<void>>);
}
