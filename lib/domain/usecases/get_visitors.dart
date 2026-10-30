import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class GetVisitors {
  final VisitorRepository repository;

  const GetVisitors(this.repository);

  Future<List<Visitor>> call() => repository.getVisitors();
}
