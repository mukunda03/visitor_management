import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class DeleteVisitor {
  final VisitorRepository repository;
  const DeleteVisitor(this.repository);

  Future<void> call(String id) => repository.deleteVisitor(id);
}
