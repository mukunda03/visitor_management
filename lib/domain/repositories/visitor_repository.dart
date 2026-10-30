import 'package:visitor_management/domain/entities/visitor.dart';

abstract class VisitorRepository {
  Future<List<Visitor>> getVisitors();

  Future<Visitor> getVisitorById(String id);

  Future<Visitor> addVisitor(Visitor visitor);

  Future<Visitor> updateVisitor(Visitor visitor);

  Future<void> deleteVisitor(String id);

  Future<Visitor> updateStatus({
    required String id,
    required String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  });
}
