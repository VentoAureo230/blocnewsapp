import 'package:blocnewsapp/features/authentication/data/models/authentication.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'authentication_api_service.g.dart';

@RestApi()
abstract class AuthenticationApiService {
  factory AuthenticationApiService(Dio dio, {String? baseUrl}) =
      _AuthenticationApiService;

  @POST("/authentication/login")
  Future<HttpResponse<AuthenticationModel>> login({
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST("/authentication/register")
  Future<HttpResponse<AuthenticationModel>> register({
    @Field("username") required String username,
    @Field("email") required String email,
    @Field("password") required String password,
  });
}