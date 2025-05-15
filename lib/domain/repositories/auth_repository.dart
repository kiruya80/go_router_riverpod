import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../../data/models/user.dart';
import '../../core/error/app_error.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<User> getProfile(String token);
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}