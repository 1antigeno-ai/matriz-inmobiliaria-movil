import 'package:flutter/material.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_card.dart';

class AppointmentsListView extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final Function(AppointmentModel) onTap;
  final Function(AppointmentModel) onEdit;
  final Function(AppointmentModel) onDelete;
  final Function(AppointmentModel, AppointmentStatus) onStatusChange;

  const AppointmentsListView({
    super.key,
    required this.appointments,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron citas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta ajustar los filtros',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppointmentCard(
            appointment: appointment,
            onTap: () => onTap(appointment),
            onEdit: () => onEdit(appointment),
            onDelete: () => onDelete(appointment),
            onStatusChange: (status) => onStatusChange(appointment, status),
          ),
        );
      },
    );
  }
}
