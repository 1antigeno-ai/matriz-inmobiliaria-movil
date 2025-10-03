import 'package:equatable/equatable.dart';
import '../data/models/appointment_model.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentEvent {}

class CreateAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const CreateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class UpdateAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const UpdateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class DeleteAppointment extends AppointmentEvent {
  final String id;

  const DeleteAppointment(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateAppointmentStatus extends AppointmentEvent {
  final String id;
  final AppointmentStatus status;

  const UpdateAppointmentStatus(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class RescheduleAppointment extends AppointmentEvent {
  final String id;
  final DateTime newDate;
  final String newTime;

  const RescheduleAppointment(this.id, this.newDate, this.newTime);

  @override
  List<Object?> get props => [id, newDate, newTime];
}

class FilterAppointments extends AppointmentEvent {
  final AppointmentStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const FilterAppointments({
    this.status,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [status, startDate, endDate, searchQuery];
}

class ClearFilters extends AppointmentEvent {}
