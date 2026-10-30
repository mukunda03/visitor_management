import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/domain/entities/visitor.dart';

class VisitorFormScreen extends StatelessWidget {
  final Visitor? visitor;
  const VisitorFormScreen({super.key, this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          visitor == null ? AppStrings.registerVisitor : AppStrings.editVisitor,
        ),
      ),
      body: const Center(child: Text("Form!")),
    );
  }
}
