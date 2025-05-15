import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../models/login_request.dart';
import '../../../models/login_response.dart';
import '../../../models/user.dart';
import '../../../../core/constants/api_constants.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(@Body() LoginRequest loginRequest);

  @GET(ApiConstants.profileEndpoint)
  Future<User> getProfile(@Header('Authorization') String token);
}