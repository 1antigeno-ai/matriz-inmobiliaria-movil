import 'package:equatable/equatable.dart';
import '../data/models/appointment_model.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;
  final List<AppointmentModel> filteredAppointments;
  final AppointmentStatus? statusFilter;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final String? searchQuery;

  const AppointmentLoaded({
    required this.appointments,
    required this.filteredAppointments,
    this.statusFilter,
    this.startDateFilter,
    this.endDateFilter,
    this.searchQuery,
  });

  int get totalCount => appointments.length;
  int get programadaCount =>
      appointments.where((a) => a.status == AppointmentStatus.programada).length;
  int get confirmadaCount =>
      appointments.where((a) => a.status == AppointmentStatus.confirmada).length;
  int get completadaCount =>
      appointments.where((a) => a.status == AppointmentStatus.completada).length;
  int get canceladaCount =>
      appointments.where((a) => a.status == AppointmentStatus.cancelada).length;

  AppointmentLoaded copyWith({
    List<AppointmentModel>? appointments,
    List<AppointmentModel>? filteredAppointments,
    AppointmentStatus? statusFilter,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    String? searchQuery,
    bool clearStatusFilter = false,
    bool clearDateFilters = false,
    bool clearSearchQuery = false,
  }) {
    return AppointmentLoaded(
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      startDateFilter: clearDateFilters ? null : (startDateFilter ?? this.startDateFilter),
      endDateFilter: clearDateFilters ? null : (endDateFilter ?? this.endDateFilter),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }

  @override
  List<Object?> get props => [
        appointments,
        filteredAppointments,
        statusFilter,
        startDateFilter,
        endDateFilter,
        searchQuery,
      ];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentOperationSuccess extends AppointmentState {
  final String message;

  const AppointmentOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
