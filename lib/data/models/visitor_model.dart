import 'package:visitor_management/domain/entities/visitor.dart';

class VisitorModel extends Visitor {
  const VisitorModel({
    required super.id,
    required super.name,
    required super.mobile,
    super.email,
    required super.visitorType,
    required super.project,
    required super.purpose,
    required super.status,
    required super.createdAt,
    super.checkInTime,
    super.checkOutTime,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      email: json['email'] as String? ?? '',
      visitorType: json['visitor_type'] as String? ?? '',
      project: json['project'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      checkInTime: _parseDate(json['check_in_time']),
      checkOutTime: _parseDate(json['check_out_time']),
    );
  }

  factory VisitorModel.fromEntity(Visitor visitor) {
    return VisitorModel(
      id: visitor.id,
      name: visitor.name,
      mobile: visitor.mobile,
      email: visitor.email,
      visitorType: visitor.visitorType,
      project: visitor.project,
      purpose: visitor.purpose,
      status: visitor.status,
      createdAt: visitor.createdAt,
      checkInTime: visitor.checkInTime,
      checkOutTime: visitor.checkOutTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'visitor_type': visitorType,
      'project': project,
      'purpose': purpose,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'check_in_time': checkInTime?.toUtc().toIso8601String(),
      'check_out_time': checkOutTime?.toUtc().toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
