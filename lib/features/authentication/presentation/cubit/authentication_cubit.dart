import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/login.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/logout.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/register.dart';
import 'package:blocnewsapp/features/authentication/presentation/cubit/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthenticationCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
  ) : super(const AuthenticationInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthenticationLoading());

    final dataState = await _loginUseCase(
      params: LoginParams(email: email, password: password),
    );

    if (dataState is DataSuccess) {
      emit(AuthenticationSuccess(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(AuthenticationError(dataState.error!));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const AuthenticationLoading());

    final dataState = await _registerUseCase(
      params: RegisterParams(username: username, email: email, password: password),
    );

    if (dataState is DataSuccess) {
      emit(AuthenticationSuccess(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(AuthenticationError(dataState.error!));
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    emit(const AuthenticationInitial());
  }
}
