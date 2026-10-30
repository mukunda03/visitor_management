import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/core/constants/app_colors.dart';

import '../../core/constants/app_strings.dart';
import '../bloc/visitor_bloc.dart';
import '../bloc/visitor_state.dart';
import 'dashboard_screen.dart';
import 'scanner_screen.dart';
import 'visitor_list_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  Widget _buildPage() {
    switch (_index) {
      case 1:
        return const VisitorListScreen();
      case 2:
        return const ScannerScreen();
      default:
        return DashboardScreen(onNavigate: _goTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitorBloc, VisitorState>(
      listenWhen: (previous, current) =>
          previous.messageId != current.messageId && current.message != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.isError ? AppColors.error : null,
            ),
          );
      },
      child: Scaffold(
        body: _buildPage(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _goTo,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: AppStrings.dashboard,
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: AppStrings.visitors,
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              label: AppStrings.scan,
            ),
          ],
        ),
      ),
    );
  }
}
