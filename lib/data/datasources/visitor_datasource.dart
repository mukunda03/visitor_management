import 'package:visitor_management/data/models/visitor_model.dart';

abstract class VisitorDatasource {
  Future<List<VisitorModel>> getVisitors();

  Future<VisitorModel> getVisitorById(String id);

  Future<VisitorModel> addVisitor(VisitorModel visitor);

  Future<VisitorModel> updateVisitor(VisitorModel visitor);

  Future<void> deleteVisitor(String id);

  Future<VisitorModel> updateStatus({
    required String id,
    required String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  });
}
