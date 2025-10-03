import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final SupabaseClient _supabase;

  AppointmentRepository(this._supabase);

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .order('appointment_date', ascending: true)
          .order('appointment_time', ascending: true);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar las citas: $e');
    }
  }

  Future<AppointmentModel> createAppointment(AppointmentModel appointment) async {
    try {
      final response = await _supabase
          .from('appointments')
          .insert(appointment.toInsertJson())
          .select()
          .single();

      return AppointmentModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear la cita: $e');
    }
  }

  Future<AppointmentModel> updateAppointment(AppointmentModel appointment) async {
    try {
      final response = await _supabase
          .from('appointments')
          .update({
            'full_name': appointment.fullName,
            'phone_number': appointment.phoneNumber,
            'email': appointment.email,
            'document_type': appointment.documentType,
            'document_number': appointment.documentNumber,
            'appointment_date': appointment.appointmentDate.toIso8601String().split('T')[0],
            'appointment_time': appointment.appointmentTime,
            'service': appointment.service,
            'details': appointment.details,
            'status': appointment.status.value,
          })
          .eq('id', appointment.id)
          .select()
          .single();

      return AppointmentModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar la cita: $e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _supabase.from('appointments').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar la cita: $e');
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(String id, AppointmentStatus status) async {
    try {
      final response = await _supabase
          .from('appointments')
          .update({'status': status.value})
          .eq('id', id)
          .select()
          .single();

      return AppointmentModel.fromJson(response);
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
      final response = await _supabase
          .from('appointments')
          .update({
            'appointment_date': newDate.toIso8601String().split('T')[0],
            'appointment_time': newTime,
          })
          .eq('id', id)
          .select()
          .single();

      return AppointmentModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al reagendar la cita: $e');
    }
  }
}
