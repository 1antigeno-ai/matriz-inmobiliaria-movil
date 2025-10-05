import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  static const String _appointmentsKey = 'appointments';
  final SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  AppointmentRepository(this._prefs);

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final String? appointmentsJson = _prefs.getString(_appointmentsKey);

      if (appointmentsJson == null || appointmentsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = json.decode(appointmentsJson);
      final appointments = decoded
          .map((json) => AppointmentModel.fromJson(json))
          .toList();

      appointments.sort((a, b) {
        final dateComparison = a.appointmentDate.compareTo(b.appointmentDate);
        if (dateComparison != 0) return dateComparison;
        return a.appointmentTime.compareTo(b.appointmentTime);
      });

      return appointments;
    } catch (e) {
      throw Exception('Error al cargar las citas: $e');
    }
  }

  Future<AppointmentModel> createAppointment(AppointmentModel appointment) async {
    try {
      final appointments = await getAppointments();

      final newAppointment = appointment.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      appointments.add(newAppointment);
      await _saveAppointments(appointments);

      return newAppointment;
    } catch (e) {
      throw Exception('Error al crear la cita: $e');
    }
  }

  Future<AppointmentModel> updateAppointment(AppointmentModel appointment) async {
    try {
      final appointments = await getAppointments();
      final index = appointments.indexWhere((a) => a.id == appointment.id);

      if (index == -1) {
        throw Exception('Cita no encontrada');
      }

      final updatedAppointment = appointment.copyWith(
        updatedAt: DateTime.now(),
      );

      appointments[index] = updatedAppointment;
      await _saveAppointments(appointments);

      return updatedAppointment;
    } catch (e) {
      throw Exception('Error al actualizar la cita: $e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      final appointments = await getAppointments();
      appointments.removeWhere((a) => a.id == id);
      await _saveAppointments(appointments);
    } catch (e) {
      throw Exception('Error al eliminar la cita: $e');
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(
    String id,
    AppointmentStatus status,
  ) async {
    try {
      final appointments = await getAppointments();
      final index = appointments.indexWhere((a) => a.id == id);

      if (index == -1) {
        throw Exception('Cita no encontrada');
      }

      final updatedAppointment = appointments[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      appointments[index] = updatedAppointment;
      await _saveAppointments(appointments);

      return updatedAppointment;
    } catch (e) {
      throw Exception('Error al actualizar el estado: $e');
    }
  }

  Future<AppointmentModel> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
  ) async {
    try {
      final appointments = await getAppointments();
      final index = appointments.indexWhere((a) => a.id == id);

      if (index == -1) {
        throw Exception('Cita no encontrada');
      }

      final updatedAppointment = appointments[index].copyWith(
        appointmentDate: newDate,
        appointmentTime: newTime,
        updatedAt: DateTime.now(),
      );

      appointments[index] = updatedAppointment;
      await _saveAppointments(appointments);

      return updatedAppointment;
    } catch (e) {
      throw Exception('Error al reagendar la cita: $e');
    }
  }

  Future<void> _saveAppointments(List<AppointmentModel> appointments) async {
    final jsonList = appointments.map((a) => a.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _prefs.setString(_appointmentsKey, jsonString);
  }
}
