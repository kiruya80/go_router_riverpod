import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인 상태를 관리하는 Provider
final isLoggedInProvider = StateProvider<bool>((ref) => false);

// GoRouter 설정 (라우트 가드 포함)
final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // 로그인되지 않은 사용자가 /profile 경로에 접근하려고 하면 /login으로 리디렉션
      if (state.fullPath == '/profile' && !isLoggedIn) {
        return '/login';
      }
      // 로그인된 사용자가 /login 경로에 접근하려고 하면 /profile으로 리디렉션 (이미 로그인했으므로)
      if (state.fullPath == '/login' && isLoggedIn) {
        return '/profile';
      }
      return null; // 리디렉션 없음
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
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
      title: 'GoRouter with Riverpod Auth',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Please log in'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 실제로는 로그인 처리 로직이 들어가야 함
                ref.read(isLoggedInProvider.notifier).state = true;
                context.go('/profile'); // 로그인 성공 후 프로필 화면으로 이동
              },
              child: const Text('Log In'),
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
    final isLoggedIn = ref.watch(isLoggedInProvider);

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
                ref.read(isLoggedInProvider.notifier).state = false;
                context.go('/'); // 로그아웃 후 홈 화면으로 이동
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