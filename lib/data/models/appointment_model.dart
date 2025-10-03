import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String documentType;
  final String documentNumber;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String service;
  final String details;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const AppointmentModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.documentType,
    required this.documentNumber,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.service,
    required this.details,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      documentType: json['document_type'] as String,
      documentNumber: json['document_number'] as String,
      appointmentDate: DateTime.parse(json['appointment_date'] as String),
      appointmentTime: json['appointment_time'] as String,
      service: json['service'] as String,
      details: json['details'] as String? ?? '',
      status: AppointmentStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'document_type': documentType,
      'document_number': documentNumber,
      'appointment_date': appointmentDate.toIso8601String().split('T')[0],
      'appointment_time': appointmentTime,
      'service': service,
      'details': details,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'document_type': documentType,
      'document_number': documentNumber,
      'appointment_date': appointmentDate.toIso8601String().split('T')[0],
      'appointment_time': appointmentTime,
      'service': service,
      'details': details,
      'status': status.value,
      'user_id': userId,
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? documentType,
    String? documentNumber,
    DateTime? appointmentDate,
    String? appointmentTime,
    String? service,
    String? details,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      service: service ?? this.service,
      details: details ?? this.details,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        documentType,
        documentNumber,
        appointmentDate,
        appointmentTime,
        service,
        details,
        status,
        createdAt,
        updatedAt,
        userId,
      ];
}

enum AppointmentStatus {
  programada('programada', 'Programada'),
  confirmada('confirmada', 'Confirmada'),
  completada('completada', 'Completada'),
  cancelada('cancelada', 'Cancelada');

  final String value;
  final String label;

  const AppointmentStatus(this.value, this.label);

  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => AppointmentStatus.programada,
    );
  }
}
