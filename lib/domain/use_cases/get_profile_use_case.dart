import '../../core/error/app_error.dart';
import '../../data/models/user.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/impl/auth_repository_impl.dart' show authRepositoryProvider;

class GetProfileUseCase {
  final AuthRepository _authRepository;

  GetProfileUseCase(this._authRepository);

  Future<User> execute() async {
    final token = await _authRepository.getToken();
    if (token == null) {
      throw UnauthorizedError('로그인되지 않았습니다.');
    }
    return _authRepository.getProfile(token);
  }
}

final getProfileUseCaseProvider = FutureProvider<GetProfileUseCase>((ref) async {
  final authRepository = await ref.read(authRepositoryProvider.future);
  return GetProfileUseCase(authRepository);
});
