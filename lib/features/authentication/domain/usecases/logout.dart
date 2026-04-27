import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';

class LogoutUseCase implements Usecase<void, void> {
  final AuthenticationRepository _authenticationRepository;

  LogoutUseCase(this._authenticationRepository);

  @override
  Future<void> call({void params}) {
    return _authenticationRepository.clearStoredToken();
  }
}
