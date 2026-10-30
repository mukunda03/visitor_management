import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/errors/app_exception.dart';
import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class CheckOutVisitor {
  final VisitorRepository repository;
  const CheckOutVisitor(this.repository);

  Future<Visitor> call(Visitor visitor) async {
    if (visitor.isRegistered) {
      throw const AppException(AppStrings.notCheckedIn);
    }
    if (visitor.isCheckedOut) {
      throw const AppException(AppStrings.visitCompleted);
    }
    return repository.updateStatus(
      id: visitor.id,
      status: AppStrings.statusCheckedOut,
      checkOutTime: DateTime.now(),
    );
  }
}
