import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth_required.dart';
import '../../../data/models/login_request.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/impl/auth_repository_impl.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../../domain/use_cases/get_profile_use_case.dart';
import '../../../domain/repositories/auth_repository.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<User?> {
  late final LoginUseCase _loginUseCase;
  late final GetProfileUseCase _getProfileUseCase;
  late final AuthRepository _authRepository;
  late final GoRouter _router;

  @override
  Future<User?> build() async {
    _loginUseCase = await ref.read(loginUseCaseProvider.future);
    _getProfileUseCase = await ref.read(getProfileUseCaseProvider.future);
    _authRepository = await ref.read(authRepositoryProvider.future);
    _router = ref.read(goRouterProvider);

    final token = await _authRepository.getToken();
    if (token != null) {
      final user = await _getProfileUseCase.execute();
      _router.go('/profile');
      return user;
    } else {
      _router.go('/login');
      return null;
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final loginRequest = LoginRequest(username: username, password: password);
      final LoginResponse response = await _loginUseCase.execute(loginRequest);
      await _authRepository.saveToken(response.token);
      final user = await _getProfileUseCase.execute();
      state = AsyncData(user);
      _router.go('/profile');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await _authRepository.clearToken();
    state = const AsyncData(null);
    _router.go('/login');
  }

  Future<void> getProfile() async {
    state = const AsyncValue.loading();
    try {
      final user = await _getProfileUseCase.execute();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _authRepository.getToken();
    if (token != null) {
      await getProfile();
      if (state.hasValue) {
        _router.go('/profile');
      } else {
        _router.go('/login');
      }
    } else {
      _router.go('/login');
    }
  }
}
