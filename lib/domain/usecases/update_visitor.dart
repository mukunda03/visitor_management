import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class UpdateVisitor {
  final VisitorRepository repository;
  const UpdateVisitor(this.repository);

  Future<Visitor> call(Visitor visitor) => repository.updateVisitor(visitor);
}
