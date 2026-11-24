import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/setup_screen.dart';
import '../../features/home/home_shell.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(sessionProvider, (_, __) => notifyListeners());
    _ref.listen(adminExistsProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final admin = _ref.read(adminExistsProvider);
    if (admin.isLoading) return loc == '/splash' ? null : '/splash';
    final hasAdmin = admin.valueOrNull ?? false;
    final loggedIn = _ref.read(sessionProvider).isLoggedIn;
    if (!hasAdmin) return loc == '/setup' ? null : '/setup';
    if (!loggedIn) return loc == '/login' ? null : '/login';
    if (loc == '/login' || loc == '/setup' || loc == '/splash') return '/home';
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/setup', builder: (_, __) => const SetupScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeShell()),
    ],
  );
});
