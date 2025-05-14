import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_log_in.dart';

class AuthRequired extends ConsumerWidget {
  final Widget child;
  final String? redirectTo; // 접근 실패 시 리디렉션할 경로

  const AuthRequired({super.key, required this.child, this.redirectTo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      if (redirectTo != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(redirectTo!);
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator())); // 로딩 처리
      }
      return const Center(child: Text('로그인이 필요합니다.')); // 기본 메시지
    }
    return child;
  }
}

class AdminRequired extends ConsumerWidget {
  final Widget child;
  final String redirectTo;

  const AdminRequired({super.key, required this.child, required this.redirectTo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    // final isAdmin = ref.watch(isAdminProvider);

    // if (!isLoggedIn || !isAdmin) {
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(redirectTo);
      });
      return const Scaffold(body: Center(child: Text('관리자 권한이 필요합니다.')));
    }
    return child;
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
        redirect: (_, __) => ref.read(isLoggedInProvider) ? '/profile' : null,
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const AuthRequired(child: ProfileScreen(), redirectTo: '/login'),
      ),
      // GoRoute(
      //   path: '/admin',
      //   builder: (_, __) => const AdminRequired(child: AdminScreen(), redirectTo: '/login'),
      // ),
      // GoRoute(
      //   path: '/settings',
      //   builder: (_, __) => const AuthRequired(child: SettingsScreen(), redirectTo: '/login'),
      // ),
    ],
  );
});