import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/theme/app_theme.dart';
import 'package:visitor_management/data/datasources/visitor_local_datasource.dart';
import 'package:visitor_management/data/repositories/visitor_repository_impl.dart';
import 'package:visitor_management/domain/repositories/visitor_repository.dart';
import 'package:visitor_management/domain/usecases/add_visitors.dart';
import 'package:visitor_management/domain/usecases/check_in_visitor.dart';
import 'package:visitor_management/domain/usecases/check_out_visitor.dart';
import 'package:visitor_management/domain/usecases/delete_visitor.dart';
import 'package:visitor_management/domain/usecases/get_visitors.dart';
import 'package:visitor_management/domain/usecases/update_visitor.dart';
import 'package:visitor_management/presentation/bloc/visitor_bloc.dart';
import 'package:visitor_management/presentation/bloc/visitor_event.dart';
import 'package:visitor_management/presentation/screens/home_shell.dart';

void main() {
  final repository = VisitorRepositoryImpl(VisitorLocalDatasource());
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final VisitorRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<VisitorRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => VisitorBloc(
          getVisitors: GetVisitors(repository),
          addVisitors: AddVisitors(repository),
          updateVisitor: UpdateVisitor(repository),
          deleteVisitor: DeleteVisitor(repository),
          checkInVisitor: CheckInVisitor(repository),
          checkOutVisitor: CheckOutVisitor(repository),
        )..add(const LoadVisitors()),
        child: MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeShell(),
        ),
      ),
    );
  }
}
