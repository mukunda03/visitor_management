import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class GetVisitorById {
  final VisitorRepository repository;
  const GetVisitorById(this.repository);

  Future<Visitor> call(String id) => repository.getVisitorById(id);
}
