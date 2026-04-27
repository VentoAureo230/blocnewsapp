import 'package:blocnewsapp/core/resources/app_error.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  const ApiErrorHandler();

  AppError handle(Object error) {
    if (error is DioException) {
      return _mapDioException(error);
    }

    return const AppError(
      message: 'Une erreur inattendue est survenue.',
    );
  }

  AppError fromResponse(Response<dynamic> response) {
    final data = response.data;
    final message = _extractMessage(data);

    return AppError(
      statusCode: response.statusCode,
      code: _extractCode(data),
      message: message ?? _messageFromStatusCode(response.statusCode),
      isRetryable: response.statusCode != null && response.statusCode! >= 500,
    );
  }

  AppError _mapDioException(DioException error) {
    if (error.type == DioExceptionType.badResponse && error.response != null) {
      return fromResponse(error.response!);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppError(
          message: 'Le serveur met trop de temps a repondre. Reessayez dans un instant.',
          isNetworkError: true,
          isRetryable: true,
        );
      case DioExceptionType.connectionError:
        return const AppError(
          message: 'Impossible de contacter le serveur. Verifiez votre connexion Internet.',
          isNetworkError: true,
          isRetryable: true,
        );
      case DioExceptionType.badCertificate:
        return const AppError(
          message: 'La connexion au serveur a ete refusee pour des raisons de securite.',
        );
      case DioExceptionType.cancel:
        return const AppError(
          message: 'La requete a ete annulee.',
        );
      case DioExceptionType.badResponse:
        return AppError(
          statusCode: error.response?.statusCode,
          message: _messageFromStatusCode(error.response?.statusCode),
        );
      case DioExceptionType.unknown:
        return const AppError(
          message: 'Une erreur reseau est survenue. Reessayez plus tard.',
          isNetworkError: true,
          isRetryable: true,
        );
    }
  }

  String? _extractCode(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      if (code is String && code.trim().isNotEmpty) {
        return code.trim();
      }
    }

    return null;
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      final errorText = data['error'];

      if (message is String && message.trim().isNotEmpty) {
        return _mapApiMessage(message.trim());
      }

      if (message is List && message.isNotEmpty) {
        return message
            .map((item) => _mapApiMessage(item.toString().trim()))
            .join('\n');
      }

      if (errorText is String && errorText.trim().isNotEmpty) {
        return _mapApiMessage(errorText.trim());
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return _mapApiMessage(data.trim());
    }

    return null;
  }

  String _messageFromStatusCode(int? statusCode) {
    if (statusCode == 400) {
      return 'Les informations envoyees sont invalides.';
    }
    if (statusCode == 401) {
      return 'Le mot de passe est incorrect.';
    }
    if (statusCode == 404) {
      return 'Aucun compte n\'existe avec cet email.';
    }
    if (statusCode == 409) {
      return 'Un compte existe deja avec cet email.';
    }
    if (statusCode == 500) {
      return 'Le serveur a rencontre un probleme. Reessayez plus tard.';
    }

    return 'Le serveur a renvoye une reponse inattendue.';
  }

  String _mapApiMessage(String message) {
    switch (message) {
      case 'Email and password are required':
        return 'L\'email et le mot de passe sont obligatoires.';
      case 'Email, username and password are required':
        return 'L\'email, le nom d\'utilisateur et le mot de passe sont obligatoires.';
      case 'Email format is invalid':
        return 'Le format de l\'email est invalide.';
      case 'Password must contain at least 8 characters':
        return 'Le mot de passe doit contenir au moins 8 caracteres.';
      case 'No such user':
        return 'Aucun compte n\'existe avec cet email.';
      case 'Invalid password':
        return 'Le mot de passe est incorrect.';
      case 'Wrong credentials':
        return 'Identifiants incorrects. Verifiez votre email et votre mot de passe.';
      case 'User already exists':
        return 'Un compte existe deja avec cet email.';
      case 'Unable to read user data':
        return 'Impossible de recuperer les donnees utilisateur.';
      case 'Unable to create user':
        return 'Impossible de creer le compte pour le moment.';
      case 'Unable to generate token':
        return 'Impossible d\'ouvrir votre session pour le moment.';
      default:
        return message;
    }
  }
}