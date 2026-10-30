import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/errors/app_exception.dart';
import 'package:visitor_management/domain/entities/visitor.dart';
import 'package:visitor_management/domain/usecases/add_visitors.dart';
import 'package:visitor_management/domain/usecases/check_in_visitor.dart';
import 'package:visitor_management/domain/usecases/check_out_visitor.dart';
import 'package:visitor_management/domain/usecases/delete_visitor.dart';
import 'package:visitor_management/domain/usecases/get_visitors.dart';
import 'package:visitor_management/domain/usecases/update_visitor.dart';
import 'package:visitor_management/presentation/bloc/visitor_event.dart';
import 'package:visitor_management/presentation/bloc/visitor_state.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final GetVisitors getVisitors;
  final AddVisitors addVisitors;
  final UpdateVisitor updateVisitor;
  final DeleteVisitor deleteVisitor;
  final CheckInVisitor checkInVisitor;
  final CheckOutVisitor checkOutVisitor;

  final Set<String> _busyIds = {};

  VisitorBloc({
    required this.getVisitors,
    required this.addVisitors,
    required this.updateVisitor,
    required this.deleteVisitor,
    required this.checkInVisitor,
    required this.checkOutVisitor,
  }) : super(const VisitorState()) {
    on<LoadVisitors>(_onLoad);
    on<AddVisitorEvent>(_onAdd);
    on<UpdateVisitorEvent>(_onUpdate);
    on<DeleteVisitorEvent>(_onDelete);
    on<CheckInEvent>(_onCheckIn);
    on<CheckOutEvent>(_onCheckOut);
    on<SearchChanged>(_onSearch);
  }
  String _errorText(Object e) =>
      e is AppException ? e.message : AppStrings.somethingWentWrong;

  VisitorState _feedback(String messsage, {bool isError = false}) {
    return state.copyWith(
      message: messsage,
      isError: isError,
      messageId: state.messageId + 1,
    );
  }

  List<Visitor> _replace(Visitor updated) {
    return state.visitors.map((v) => v.id == updated.id ? updated : v).toList();
  }

  Future<void> _onLoad(LoadVisitors event, Emitter<VisitorState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final visitors = await getVisitors();
      emit(state.copyWith(status: LoadStatus.success, visitors: visitors));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: _errorText(e)));
    }
  }

  Future<void> _onAdd(AddVisitorEvent event, Emitter<VisitorState> emit) async {
    try {
      final created = await addVisitors(event.visitor);
      emit(
        state.copyWith(
          visitors: [...state.visitors, created],
          message: AppStrings.visitorRegistered,
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      emit(_feedback(_errorText(e), isError: true));
    }
  }

  Future<void> _onUpdate(
    UpdateVisitorEvent event,
    Emitter<VisitorState> emit,
  ) async {
    try {
      final updated = await updateVisitor(event.visitor);
      emit(
        state.copyWith(
          visitors: _replace(updated),
          message: AppStrings.visitorUpdated,
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      emit(_feedback(_errorText(e), isError: true));
    }
  }

  Future<void> _onDelete(
    DeleteVisitorEvent event,
    Emitter<VisitorState> emit,
  ) async {
    try {
      await deleteVisitor(event.id);
      emit(
        state.copyWith(
          visitors: state.visitors.where((v) => v.id != event.id).toList(),
          message: AppStrings.visitorDeleted,
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      emit(_feedback(_errorText(e), isError: true));
    }
  }

  Future<void> _onCheckIn(
    CheckInEvent event,
    Emitter<VisitorState> emit,
  ) async {
    if (!_busyIds.add(event.id)) return;
    try {
      final current = state.visitorById(event.id);
      if (current == null) {
        emit(_feedback(AppStrings.visitorNotFound, isError: true));
        return;
      }
      final updated = await checkInVisitor(current);
      emit(
        state.copyWith(
          visitors: _replace(updated),
          message: AppStrings.checkedInSuccess,
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      emit(_feedback(_errorText(e), isError: true));
    } finally {
      _busyIds.remove(event.id);
    }
  }

  Future<void> _onCheckOut(
    CheckOutEvent event,
    Emitter<VisitorState> emit,
  ) async {
    if (!_busyIds.add(event.id)) return;
    try {
      final current = state.visitorById(event.id);
      if (current == null) {
        emit(_feedback(AppStrings.visitorNotFound, isError: true));
        return;
      }
      final updated = await checkOutVisitor(current);
      emit(
        state.copyWith(
          visitors: _replace(updated),
          message: AppStrings.checkedOutSuccess,
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      emit(_feedback(_errorText(e), isError: true));
    } finally {
      _busyIds.remove(event.id);
    }
  }

  void _onSearch(SearchChanged event, Emitter<VisitorState> emit) {
    emit(state.copyWith(query: event.query));
  }
}
