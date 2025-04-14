import 'package:flutter/material.dart';
import 'package:uni_mobile/core/widgets/bottom_nav_bar.dart';
import '../widgets/app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      appBar: (currentRoute == '/profile' || currentRoute == '/login')
          ? null
          : const CustomAppBar(),
      body: child,
      bottomNavigationBar: BottomNavBar(
        onItemTapped: (index) {
          // Handle navigation
        },
      ),
    );
  }
}