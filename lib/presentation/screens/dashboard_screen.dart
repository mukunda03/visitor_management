import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/core/constants/app_colors.dart';
import 'package:visitor_management/core/constants/app_numbers.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/presentation/bloc/visitor_bloc.dart';
import 'package:visitor_management/presentation/bloc/visitor_event.dart';
import 'package:visitor_management/presentation/bloc/visitor_state.dart';
import 'package:visitor_management/presentation/screens/visitor_form_screen.dart';
import 'package:visitor_management/presentation/widgets/custom_button.dart';
import 'package:visitor_management/presentation/widgets/dashboard_stat_card.dart';
import 'package:visitor_management/presentation/widgets/error_view.dart';
import 'package:visitor_management/presentation/widgets/loading_view.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.appName)),
      body: BlocBuilder<VisitorBloc, VisitorState>(
        builder: (context, state) {
          final isLoading =
              state.status == LoadStatus.inital ||
              state.status == LoadStatus.loading;
          if (isLoading && state.visitors.isEmpty) {
            return const LoadingView();
          }

          if (state.status == LoadStatus.failure && state.visitors.isEmpty) {
            return ErrorView(
              message: state.error ?? AppStrings.somethingWentWrong,
              onRetry: () =>
                  context.read<VisitorBloc>().add(const LoadVisitors()),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppNumbers.spaceLg),
            children: [
              DashboardStatCard(
                title: AppStrings.totalVisitorsToday,
                value: state.totalToday,
                icon: Icons.people,
                color: AppColors.registered,
              ),
              const SizedBox(height: AppNumbers.spaceMd),
              DashboardStatCard(
                title: AppStrings.currentlyCheckedIn,
                value: state.checkedInCount,
                icon: Icons.login,
                color: AppColors.checkedIn,
              ),
              const SizedBox(height: AppNumbers.spaceMd),
              DashboardStatCard(
                title: AppStrings.checkedOutToday,
                value: state.checkedOutToday,
                icon: Icons.logout,
                color: AppColors.checkedOut,
              ),
              const SizedBox(height: AppNumbers.spaceXl),
              CustomButton(
                label: AppStrings.registerVisitor,
                icon: Icons.person_add_alt_1,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VisitorFormScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppNumbers.spaceMd),
              CustomButton(
                label: AppStrings.scanQrCode,
                icon: Icons.qr_code_scanner,
                isOutlined: true,
                onPressed: () => onNavigate(2),
              ),
              const SizedBox(height: AppNumbers.spaceMd),
              CustomButton(
                label: AppStrings.visitorList,
                icon: Icons.list_alt,
                isOutlined: true,
                onPressed: () => onNavigate(1),
              ),
            ],
          );
        },
      ),
    );
  }
}
