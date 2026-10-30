import 'package:visitor_management/domain/entities/visitor.dart';

enum LoadStatus { inital, loading, success, failure }

class VisitorState {
  final LoadStatus status;
  final List<Visitor> visitors;
  final String query;
  final String? error;

  final String? message;
  final bool isError;
  final int messageId;

  const VisitorState({
    this.status = LoadStatus.inital,
    this.visitors = const [],
    this.query = '',
    this.error,
    this.message,
    this.isError = false,
    this.messageId = 0,
  });

  List<Visitor> get filteredVisitors {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return visitors;
    return visitors
        .where((v) => v.name.toLowerCase().contains(q) || v.mobile.contains(q))
        .toList();
  }

  int get totalToday => visitors.where((v) => _isToday(v.createdAt)).length;

  int get checkedInCount => visitors.where((v) => v.isCheckedIn).length;

  int get checkedOutToday =>
      visitors.where((v) => v.isCheckedOut && _isToday(v.checkOutTime)).length;

  Visitor? visitorById(String id) {
    for (final v in visitors) {
      if (v.id == id) return v;
    }
    return null;
  }

  static bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final local = date.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  VisitorState copyWith({
    LoadStatus? status,
    List<Visitor>? visitors,
    String? query,
    String? error,
    String? message,
    bool? isError,
    int? messageId,
  }) {
    return VisitorState(
      status: status ?? this.status,
      visitors: visitors ?? this.visitors,
      query: query ?? this.query,
      error: error ?? this.error,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      messageId: messageId ?? this.messageId,
    );
  }
}
