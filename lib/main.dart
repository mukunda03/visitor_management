import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.appName)),
        body: const Center(child: Text(AppStrings.appName)),
      ),
    );
  }
}
