import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_strings.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.scanTitle)),
      body: Center(child: Text(AppStrings.scanTitle)),
    );
  }
}
