import 'package:flutter/material.dart';

import '../../core/constants/app_numbers.dart';
import '../../domain/entities/visitor.dart';
import 'status_chip.dart';

class VisitorCard extends StatelessWidget {
  final Visitor visitor;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VisitorCard({
    super.key,
    required this.visitor,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppNumbers.spaceLg,
        vertical: AppNumbers.spaceXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppNumbers.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      visitor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  StatusChip(status: visitor.status),
                ],
              ),
              const SizedBox(height: AppNumbers.spaceXs),
              Text(visitor.mobile),
              Text('${visitor.project} • ${visitor.visitorType}'),
              if (onEdit != null || onDelete != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: onDelete,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
