import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/appointment_model.dart';
import '../data/repositories/appointment_repository.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;

  AppointmentBloc(this.repository) : super(AppointmentInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CreateAppointment>(_onCreateAppointment);
    on<UpdateAppointment>(_onUpdateAppointment);
    on<DeleteAppointment>(_onDeleteAppointment);
    on<UpdateAppointmentStatus>(_onUpdateAppointmentStatus);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<FilterAppointments>(_onFilterAppointments);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    try {
      final appointments = await repository.getAppointments();
      emit(AppointmentLoaded(
        appointments: appointments,
        filteredAppointments: appointments,
      ));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await repository.createAppointment(event.appointment);
      final appointments = await repository.getAppointments();
      emit(AppointmentLoaded(
        appointments: appointments,
        filteredAppointments: appointments,
      ));
      emit(const AppointmentOperationSuccess('Cita creada exitosamente'));
      final newState = await _reloadAppointments();
      emit(newState);
    } catch (e) {
      emit(AppointmentError('Error al crear la cita: ${e.toString()}'));
      if (state is AppointmentLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onUpdateAppointment(
    UpdateAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await repository.updateAppointment(event.appointment);
      emit(const AppointmentOperationSuccess('Cita actualizada exitosamente'));
      final newState = await _reloadAppointments();
      emit(newState);
    } catch (e) {
      emit(AppointmentError('Error al actualizar la cita: ${e.toString()}'));
      if (state is AppointmentLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onDeleteAppointment(
    DeleteAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await repository.deleteAppointment(event.id);
      emit(const AppointmentOperationSuccess('Cita eliminada exitosamente'));
      final newState = await _reloadAppointments();
      emit(newState);
    } catch (e) {
      emit(AppointmentError('Error al eliminar la cita: ${e.toString()}'));
      if (state is AppointmentLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onUpdateAppointmentStatus(
    UpdateAppointmentStatus event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await repository.updateAppointmentStatus(event.id, event.status);
      emit(const AppointmentOperationSuccess('Estado actualizado exitosamente'));
      final newState = await _reloadAppointments();
      emit(newState);
    } catch (e) {
      emit(AppointmentError('Error al actualizar el estado: ${e.toString()}'));
      if (state is AppointmentLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await repository.rescheduleAppointment(event.id, event.newDate, event.newTime);
      emit(const AppointmentOperationSuccess('Cita reagendada exitosamente'));
      final newState = await _reloadAppointments();
      emit(newState);
    } catch (e) {
      emit(AppointmentError('Error al reagendar la cita: ${e.toString()}'));
      if (state is AppointmentLoaded) {
        emit(state);
      }
    }
  }

  void _onFilterAppointments(
    FilterAppointments event,
    Emitter<AppointmentState> emit,
  ) {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;
      final filtered = _applyFilters(
        currentState.appointments,
        status: event.status,
        startDate: event.startDate,
        endDate: event.endDate,
        searchQuery: event.searchQuery,
      );

      emit(currentState.copyWith(
        filteredAppointments: filtered,
        statusFilter: event.status,
        startDateFilter: event.startDate,
        endDateFilter: event.endDate,
        searchQuery: event.searchQuery,
      ));
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<AppointmentState> emit,
  ) {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;
      emit(currentState.copyWith(
        filteredAppointments: currentState.appointments,
        clearStatusFilter: true,
        clearDateFilters: true,
        clearSearchQuery: true,
      ));
    }
  }

  List<AppointmentModel> _applyFilters(
    List<AppointmentModel> appointments, {
    AppointmentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    var filtered = appointments;

    if (status != null) {
      filtered = filtered.where((a) => a.status == status).toList();
    }

    if (startDate != null) {
      filtered = filtered
          .where((a) => a.appointmentDate.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }

    if (endDate != null) {
      filtered = filtered
          .where((a) => a.appointmentDate.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((a) {
        return a.fullName.toLowerCase().contains(query) ||
            a.phoneNumber.contains(query) ||
            a.email.toLowerCase().contains(query) ||
            a.documentNumber.contains(query) ||
            a.service.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  Future<AppointmentLoaded> _reloadAppointments() async {
    final appointments = await repository.getAppointments();
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;
      final filtered = _applyFilters(
        appointments,
        status: currentState.statusFilter,
        startDate: currentState.startDateFilter,
        endDate: currentState.endDateFilter,
        searchQuery: currentState.searchQuery,
      );
      return AppointmentLoaded(
        appointments: appointments,
        filteredAppointments: filtered,
        statusFilter: currentState.statusFilter,
        startDateFilter: currentState.startDateFilter,
        endDateFilter: currentState.endDateFilter,
        searchQuery: currentState.searchQuery,
      );
    }
    return AppointmentLoaded(
      appointments: appointments,
      filteredAppointments: appointments,
    );
  }
}
