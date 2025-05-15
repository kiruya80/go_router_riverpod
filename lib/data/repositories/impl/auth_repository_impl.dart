import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data_sources/remote/api_client.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/error/app_error.dart';

const String _authTokenKey = 'authToken';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._apiClient, this._prefs);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await _apiClient.authApi.login(loginRequest);
      await saveToken(response.token);
      return response;
    } catch (e) {
      throw e is AppError ? e : NetworkError('로그인 실패');
    }
  }

  @override
  Future<User> getProfile(String token) async {
    try {
      return await _apiClient.authApi.getProfile(token);
    } catch (e) {
      throw e is AppError ? e : NetworkError('프로필 정보 가져오기 실패');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_authTokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_authTokenKey);
  }
}

final authRepositoryProvider = FutureProvider<AuthRepositoryImpl>((ref) async {
  final apiClient = ApiClient();
  final prefs = await SharedPreferences.getInstance();
  return AuthRepositoryImpl(apiClient, prefs);
});