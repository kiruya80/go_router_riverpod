import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/impl/auth_repository_impl.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<LoginResponse> execute(LoginRequest loginRequest) async {
    return _authRepository.login(loginRequest);
  }
}

final loginUseCaseProvider = FutureProvider<LoginUseCase>((ref) async {
  final authRepository = await ref.read(authRepositoryProvider.future);
  return LoginUseCase(authRepository);
});
