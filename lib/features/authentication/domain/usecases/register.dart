import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/authentication/domain/entities/authentication.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';

class RegisterParams {
  final String username;
  final String email;
  final String password;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });
}

class RegisterUseCase
    implements Usecase<DataState<AuthenticationEntity>, RegisterParams> {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase(this._authenticationRepository);

  @override
  Future<DataState<AuthenticationEntity>> call({RegisterParams? params}) {
    return _authenticationRepository.register(
      username: params!.username,
      email: params.email,
      password: params.password,
    );
  }
}
