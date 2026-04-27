import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/authentication/domain/entities/authentication.dart';

abstract class AuthenticationRepository {
  Future<DataState<AuthenticationEntity>> login({
    required String email,
    required String password,
  });

  Future<DataState<AuthenticationEntity>> register({
    required String username,
    required String email,
    required String password,
  });

  Future<String?> getStoredToken();

  Future<void> clearStoredToken();
}
