import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 가상의 로그인 서비스 (Future 반환)
Future<bool> fakeLogin(String username, String password) async {
  await Future.delayed(const Duration(seconds: 2)); // 2초 딜레이
  return username == 'test' && password == 'password';
}

// 비동기 로그인 상태를 관리하는 FutureProvider
final loginStateProvider = FutureProvider<bool>((ref) async {
  // 실제 앱에서는 로그인 API 호출 로직을 여기에 구현
  // 이 예시에서는 로그인 버튼을 누를 때 상태를 업데이트합니다.
  return false; // 초기 상태는 로그인되지 않음
});

// 리디렉션 대상을 관리하는 StateProvider
final redirectTargetProvider = StateProvider<String?>((ref) => null);

// GoRouter 설정
final goRouterProvider = Provider<GoRouter>((ref) {
  final loginState = ref.watch(loginStateProvider).valueOrNull;
  final redirectTarget = ref.watch(redirectTargetProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (redirectTarget != null) {
        final target = redirectTarget;
        ref.read(redirectTargetProvider.notifier).state = null; // 리디렉션 후 초기화
        return target;
      }

      final isLoggingIn = state.fullPath == '/login';
      final isProtectedRoute = state.fullPath == '/profile';

      // 보호된 경로에 접근 시 로그인되지 않았으면 로그인 페이지로 리디렉션
      if (isProtectedRoute && (loginState == null || !loginState)) {
        return '/login';
      }

      // 로그인 페이지에 접근 시 이미 로그인했으면 프로필 페이지로 리디렉션
      if (isLoggingIn && loginState == true) {
        return '/profile';
      }

      return null; // 리디렉션 없음
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
      ),
    ],
  );
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'GoRouter with Riverpod Async Auth',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile (Requires Login)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginAsyncValue = ref.watch(loginStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (loginAsyncValue.isLoading)
              const CircularProgressIndicator()
            else if (loginAsyncValue.hasError)
              Text('Login Failed: ${loginAsyncValue.error}')
            else
              Column(
                children: [
                  const Text('Please log in'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // 로그인 시도 및 상태 업데이트
                      final success = await fakeLogin('test', 'password');
                      // ref.read(loginStateProvider.notifier).state = AsyncValue.data(success);
                      if (success) {
                        ref.read(redirectTargetProvider.notifier).state = '/profile';
                      }
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(loginStateProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Profile Page (Logged In: $isLoggedIn)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 로그아웃 시 상태 업데이트 (간단하게 false로 설정)
                // ref.read(loginStateProvider.notifier).state = const AsyncValue.data(false);
                ref.read(redirectTargetProvider.notifier).state = '/';
              },
              child: const Text('Log Out'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}