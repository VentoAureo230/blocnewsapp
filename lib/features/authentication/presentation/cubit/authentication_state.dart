import 'package:blocnewsapp/core/resources/app_error.dart';
import 'package:blocnewsapp/features/authentication/domain/entities/authentication.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  final AuthenticationEntity? authentication;
  final AppError? error;

  const AuthenticationState({this.authentication, this.error});

  @override
  List<Object?> get props => [authentication, error];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial() : super();
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading() : super();
}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(AuthenticationEntity authentication)
      : super(authentication: authentication);
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError(AppError error) : super(error: error);
}
