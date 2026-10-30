import 'package:dio/dio.dart';
import 'package:visitor_management/core/config/env.dart';
import 'package:visitor_management/core/constants/app_strings.dart';
import 'package:visitor_management/core/errors/app_exception.dart';
import 'package:visitor_management/data/datasources/visitor_datasource.dart';
import 'package:visitor_management/data/models/visitor_model.dart';

class VisitorRemoteDatasource implements VisitorDatasource {
  static const Duration _timeout = Duration(seconds: 15);
  final Dio _dio;

  VisitorRemoteDatasource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Env.baseUrl,
              connectTimeout: _timeout,
              receiveTimeout: _timeout,
              sendTimeout: _timeout,
              headers: {
                'Content-Type': 'application/json',
                if (Env.apiKey.isNotEmpty) 'x-api-key': Env.apiKey,
              },
            ),
          );

  String _path([String? id]) {
    if (id == null) return Env.visitorsEndpoint;
    return '${Env.visitorsEndpoint}/${Uri.encodeComponent(id)}';
  }

  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  AppException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(AppStrings.timeout);
      case DioExceptionType.connectionError:
        return const AppException(AppStrings.noInternet);
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 400) {
          return const AppException(AppStrings.visitorNotFound);
        }
        return const AppException(AppStrings.serverError);

      default:
        return const AppException(AppStrings.somethingWentWrong);
    }
  }

  VisitorModel _parse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const AppException(AppStrings.somethingWentWrong);
    }
    try {
      return VisitorModel.fromJson(data);
    } catch (_) {
      throw const AppException(AppStrings.somethingWentWrong);
    }
  }

  @override
  Future<List<VisitorModel>> getVisitors() async {
    final response = await _send(() => _dio.get(_path()));
    final data = response.data;
    if (data is! List) {
      throw const AppException(AppStrings.somethingWentWrong);
    }
    return data.map(_parse).toList();
  }

  @override
  Future<VisitorModel> getVisitorById(String id) async {
    final response = await _send(() => _dio.get(_path(id)));
    return _parse(response.data);
  }

  @override
  Future<VisitorModel> addVisitor(VisitorModel visitor) async {
    final response = await _send(
      () => _dio.post(_path(), data: visitor.toJson()),
    );
    return _parse(response.data);
  }

  @override
  Future<VisitorModel> updateVisitor(VisitorModel visitor) async {
    final response = await _send(
      () => _dio.put(_path(visitor.id), data: visitor.toJson()),
    );
    return _parse(response.data);
  }

  @override
  Future<void> deleteVisitor(String id) async {
    await _send(() => _dio.delete(_path(id)));
  }

  @override
  Future<VisitorModel> updateStatus({
    required String id,
    required String status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) async {
    final body = <String, dynamic>{
      'status': status,
      if (checkInTime != null)
        'check_in_time': checkInTime.toUtc().toIso8601String(),
      if (checkOutTime != null)
        'check_out_time': checkOutTime.toUtc().toIso8601String(),
    };

    try {
      final response = await _dio.patch(_path(id), data: body);
      return _parse(response.data);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code != 404 && code != 405) throw _map(e);
    }

    // PATCH not accepted by this provider: fall back to GET + PUT.
    final current = await getVisitorById(id);
    final merged = VisitorModel.fromEntity(
      current.copyWith(
        status: status,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
      ),
    );
    return updateVisitor(merged);
  }
}
