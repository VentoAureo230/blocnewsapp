import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/authentication/domain/entities/authentication.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase
    implements Usecase<DataState<AuthenticationEntity>, LoginParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<DataState<AuthenticationEntity>> call({LoginParams? params}) {
    return _authenticationRepository.login(
      email: params!.email,
      password: params.password,
    );
  }
}
