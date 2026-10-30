import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants/app_numbers.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/visitor.dart';
import '../bloc/visitor_bloc.dart';
import '../bloc/visitor_event.dart';
import '../bloc/visitor_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/status_chip.dart';
import 'visitor_form_screen.dart';

class VisitorDetailScreen extends StatelessWidget {
  final String visitorId;

  const VisitorDetailScreen({super.key, required this.visitorId});

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  String _formatDate(DateTime? date) {
    if (date == null) return AppStrings.notAvailable;
    return _dateFormat.format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitorBloc, VisitorState>(
      builder: (context, state) {
        final visitor = state.visitorById(visitorId);

        if (visitor == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.visitorDetails)),
            body: const EmptyStateWidget(
              icon: Icons.person_off_outlined,
              title: AppStrings.visitorNotFound,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.visitorDetails),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VisitorFormScreen(visitor: visitor),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppNumbers.spaceLg),
              children: [
                _buildInfoCard(context, visitor),
                const SizedBox(height: AppNumbers.spaceLg),
                _buildQrCard(context, visitor),
                const SizedBox(height: AppNumbers.spaceLg),
                _buildTimeCard(visitor),
                const SizedBox(height: AppNumbers.spaceXl),
                _buildAction(context, visitor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context, Visitor visitor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppNumbers.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    visitor.name,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                StatusChip(status: visitor.status),
              ],
            ),
            const SizedBox(height: AppNumbers.spaceMd),
            _row(AppStrings.mobileNumber, visitor.mobile),
            _row(
              AppStrings.email,
              (visitor.email == null || visitor.email!.isEmpty)
                  ? AppStrings.notAvailable
                  : visitor.email!,
            ),
            _row(AppStrings.visitorType, visitor.visitorType),
            _row(AppStrings.project, visitor.project),
            _row(AppStrings.purposeOfVisit, visitor.purpose),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard(BuildContext context, Visitor visitor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppNumbers.spaceLg),
        child: Column(
          children: [
            QrImageView(
              data: visitor.id,
              version: QrVersions.auto,
              size: AppNumbers.qrSize,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: AppNumbers.spaceSm),
            Text(
              '${AppStrings.visitorIdLabel}: ${visitor.id}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(Visitor visitor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppNumbers.spaceLg),
        child: Column(
          children: [
            _row(AppStrings.checkInTime, _formatDate(visitor.checkInTime)),
            _row(AppStrings.checkOutTime, _formatDate(visitor.checkOutTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, Visitor visitor) {
    final bloc = context.read<VisitorBloc>();

    if (visitor.isRegistered) {
      return CustomButton(
        label: AppStrings.checkIn,
        icon: Icons.login,
        onPressed: () => bloc.add(CheckInEvent(visitor.id)),
      );
    }

    if (visitor.isCheckedIn) {
      return CustomButton(
        label: AppStrings.checkOut,
        icon: Icons.logout,
        onPressed: () => bloc.add(CheckOutEvent(visitor.id)),
      );
    }

    return const Center(
      child: Text(
        AppStrings.visitCompleted,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppNumbers.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
