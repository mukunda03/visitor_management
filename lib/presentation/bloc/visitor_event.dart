import 'package:visitor_management/domain/entities/visitor.dart';

abstract class VisitorEvent {
  const VisitorEvent();
}

class LoadVisitors extends VisitorEvent {
  const LoadVisitors();
}

class AddVisitorEvent extends VisitorEvent {
  final Visitor visitor;
  const AddVisitorEvent(this.visitor);
}

class UpdateVisitorEvent extends VisitorEvent {
  final Visitor visitor;
  const UpdateVisitorEvent(this.visitor);
}

class DeleteVisitorEvent extends VisitorEvent {
  final String id;
  const DeleteVisitorEvent(this.id);
}

class CheckInEvent extends VisitorEvent {
  final String id;
  const CheckInEvent(this.id);
}

class CheckOutEvent extends VisitorEvent {
  final String id;
  const CheckOutEvent(this.id);
}

class SearchChanged extends VisitorEvent {
  final String query;
  const SearchChanged(this.query);
}
