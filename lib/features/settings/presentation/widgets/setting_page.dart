// setting_page.dart
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чат'),
      ),
      body: const Center(
        child: Text('Здесь будет допустим Чат.'),
      ),
    );
  }
}