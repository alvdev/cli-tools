import 'package:go_router/go_router.dart';
import 'package:{{ appPackageName }}/features/home/home_screen.dart';
import 'package:{{ appPackageName }}/features/login/login_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
  ],
);
