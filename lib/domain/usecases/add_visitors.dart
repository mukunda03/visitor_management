import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class AddVisitors {
  final VisitorRepository repository;
  const AddVisitors(this.repository);

  Future<Visitor> call(Visitor visitor) => repository.addVisitor(visitor);
}
