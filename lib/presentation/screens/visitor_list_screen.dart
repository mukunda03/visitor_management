import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_strings.dart';

class VisitorListScreen extends StatelessWidget {
  const VisitorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.visitors)),
      body: Center(child: Text(AppStrings.visitors)),
    );
  }
}
