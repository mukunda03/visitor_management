import 'package:visitor_management/data/datasources/visitor_datasource.dart';
import 'package:visitor_management/data/models/visitor_model.dart';
import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final VisitorDatasource datasource;

  const VisitorRepositoryImpl(this.datasource);

  @override
  Future<List<Visitor>> getVisitors() => datasource.getVisitors();

  @override
  Future<Visitor> getVisitorById(String id) => datasource.getVisitorById(id);

  @override
  Future<Visitor> addVisitor(Visitor visitor) =>
      datasource.addVisitor(VisitorModel.fromEntity(visitor));

  @override
  Future<Visitor> updateVisitor(Visitor visitor) =>
      datasource.updateVisitor(VisitorModel.fromEntity(visitor));

  @override
  Future<void> deleteVisitor(String id) => datasource.deleteVisitor(id);

  @override
  Future<Visitor> updateStatus({
    required String id,
    required String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) {
    return datasource.updateStatus(
      id: id,
      status: status,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
    );
  }
}
