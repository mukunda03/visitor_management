import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/presentation/screens/visitor_detail_screen.dart';

import '../../core/constants/app_numbers.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/visitor.dart';
import '../bloc/visitor_bloc.dart';
import '../bloc/visitor_event.dart';
import '../bloc/visitor_state.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/visitor_card.dart';
import 'visitor_form_screen.dart';

class VisitorListScreen extends StatefulWidget {
  const VisitorListScreen({super.key});

  @override
  State<VisitorListScreen> createState() => _VisitorListScreenState();
}

class _VisitorListScreenState extends State<VisitorListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<VisitorBloc>().state.query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(Visitor visitor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VisitorDetailScreen(visitorId: visitor.id),
      ),
    );
  }

  void _openForm({Visitor? visitor}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VisitorFormScreen(visitor: visitor)),
    );
  }

  Future<void> _confirmDelete(Visitor visitor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: Text('${visitor.name}\n${AppStrings.deleteConfirmMessage}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<VisitorBloc>().add(DeleteVisitorEvent(visitor.id));
    }
  }

  Widget _buildBody(VisitorState state) {
    final isLoading =
        state.status == LoadStatus.inital || state.status == LoadStatus.loading;

    if (isLoading && state.visitors.isEmpty) {
      return const LoadingView();
    }

    if (state.status == LoadStatus.failure && state.visitors.isEmpty) {
      return ErrorView(
        message: state.error ?? AppStrings.somethingWentWrong,
        onRetry: () => context.read<VisitorBloc>().add(const LoadVisitors()),
      );
    }

    final visitors = state.filteredVisitors;

    if (visitors.isEmpty) {
      return EmptyStateWidget(
        title: AppStrings.noVisitors,
        subtitle: state.query.isEmpty ? AppStrings.noVisitorsHint : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppNumbers.spaceLg),
      itemCount: visitors.length,
      itemBuilder: (context, index) {
        final visitor = visitors[index];
        return VisitorCard(
          visitor: visitor,
          onTap: () => _openDetails(visitor),
          onEdit: () => _openForm(visitor: visitor),
          onDelete: () => _confirmDelete(visitor),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.visitors),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => _openForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppNumbers.spaceLg),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<VisitorBloc>().add(SearchChanged(value)),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<VisitorBloc>().add(const SearchChanged(''));
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppNumbers.radiusSm),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<VisitorBloc, VisitorState>(
              builder: (context, state) => _buildBody(state),
            ),
          ),
        ],
      ),
    );
  }
}
