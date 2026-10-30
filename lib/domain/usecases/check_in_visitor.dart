import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/errors/app_exception.dart';
import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';

class CheckInVisitor {
  final VisitorRepository repository;
  const CheckInVisitor(this.repository);

  Future<Visitor> call(Visitor visitor) async {
    if (visitor.isCheckedIn) {
      throw const AppException(AppStrings.alreadyCheckedIn);
    }
    if (visitor.isCheckedOut) {
      throw const AppException(AppStrings.visitCompleted);
    }
    return repository.updateStatus(
      id: visitor.id,
      status: AppStrings.statusCheckedIn,
      checkInTime: DateTime.now(),
    );
  }
}
