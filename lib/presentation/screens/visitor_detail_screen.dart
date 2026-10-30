import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_strings.dart';

class VisitorDetailScreen extends StatelessWidget {
  final String visitorId;
  const VisitorDetailScreen({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.visitorDetails)),
      body: Center(child: Text("Details for $visitorId")),
    );
  }
}
