import 'package:flutter/material.dart';
import 'package:uni_mobile/core/layout/main_layout.dart';
import 'package:uni_mobile/features/documents/presentation/doc_main_screen.dart';
import 'package:uni_mobile/core/auth/presentation/login_page.dart';
import 'package:uni_mobile/features/home/presentation/home_page.dart';
import 'package:uni_mobile/features/schedule/presentation/schedule_page.dart';
import 'package:uni_mobile/features/cart/floormap_screen.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const LoginPage(),
    '/login': (context) => const LoginPage(),
    '/schedule': (context) => MainLayout(child: const SchedulePage()),
    '/home': (context) => MainLayout(child: const HomePage()),
    '/documents': (context) => MainLayout(child: const DocMainScreen()),
    '/floor': (context) => MainLayout(child: const FloorMapScreen()),
  };
}