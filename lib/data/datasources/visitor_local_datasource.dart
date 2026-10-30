import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/errors/app_exception.dart';
import 'package:visitor_management/data/datasources/visitor_datasource.dart';
import 'package:visitor_management/data/models/visitor_model.dart';

class VisitorLocalDatasource implements VisitorDatasource {
  static const Duration _delay = Duration(milliseconds: 300);
  int _counter = 3;

  late final List<VisitorModel> _visitors = _seed();

  List<VisitorModel> _seed() {
    final now = DateTime.now();
    return [
      VisitorModel(
        id: 'VIS001',
        name: 'Rahul Sharma',
        mobile: '9876543210',
        email: 'rahul@example.com',
        visitorType: 'Customer',
        project: 'Project A',
        purpose: 'Site Visit',
        status: AppStrings.statusRegistered,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      VisitorModel(
        id: 'VIS002',
        name: 'Anita Rao',
        mobile: '9123456780',
        visitorType: 'Vendor',
        project: 'Project B',
        purpose: 'Material Delivery',
        status: AppStrings.statusCheckedIn,
        createdAt: now.subtract(const Duration(hours: 2)),
        checkInTime: now.subtract(const Duration(hours: 1)),
      ),
      VisitorModel(
        id: 'VIS003',
        name: 'Kiran M',
        mobile: '9988776655',
        email: 'kiran@example.com',
        visitorType: 'Other',
        project: 'Project C',
        purpose: 'Meeting',
        status: AppStrings.statusCheckedOut,
        createdAt: now.subtract(const Duration(hours: 5)),
        checkInTime: now.subtract(const Duration(hours: 4)),
        checkOutTime: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }

  int _indexOf(String id) {
    final index = _visitors.indexWhere((v) => v.id == id);
    if (index == -1) {
      throw const AppException(AppStrings.visitorNotFound);
    }
    return index;
  }

  @override
  Future<List<VisitorModel>> getVisitors() async {
    await Future.delayed(_delay);
    return List.of(_visitors);
  }

  @override
  Future<VisitorModel> getVisitorById(String id) async {
    await Future.delayed(_delay);
    return _visitors[_indexOf(id)];
  }

  @override
  Future<VisitorModel> addVisitor(VisitorModel visitor) async {
    await Future.delayed(_delay);
    _counter++;
    final created = VisitorModel.fromEntity(
      visitor.copyWith(id: 'VIS${_counter.toString().padLeft(3, '0')}'),
    );
    _visitors.add(created);
    return created;
  }

  @override
  Future<VisitorModel> updateVisitor(VisitorModel visitor) async {
    await Future.delayed(_delay);
    final index = _indexOf(visitor.id);
    _visitors[index] = visitor;
    return visitor;
  }

  @override
  Future<void> deleteVisitor(String id) async {
    await Future.delayed(_delay);
    _visitors.removeAt(_indexOf(id));
  }

  @override
  Future<VisitorModel> updateStatus({
    required String id,
    required String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) async {
    await Future.delayed(_delay);
    final index = _indexOf(id);
    final updated = VisitorModel.fromEntity(
      _visitors[index].copyWith(
        status: status,
        checkInTime: checkInTime,
        checkOutTime: checkInTime,
      ),
    );
    _visitors[index] = updated;
    return updated;
  }
}
