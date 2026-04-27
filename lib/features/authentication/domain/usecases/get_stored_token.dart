import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';

class GetStoredTokenUseCase implements Usecase<String?, void> {
  final AuthenticationRepository _authenticationRepository;

  GetStoredTokenUseCase(this._authenticationRepository);

  @override
  Future<String?> call({void params}) {
    return _authenticationRepository.getStoredToken();
  }
}