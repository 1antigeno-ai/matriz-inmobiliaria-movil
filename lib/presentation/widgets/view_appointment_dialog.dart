import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment_model.dart';

class ViewAppointmentDialog extends StatelessWidget {
  final AppointmentModel appointment;

  const ViewAppointmentDialog({
    super.key,
    required this.appointment,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case AppointmentStatus.programada:
        return const Color(0xFF3B82F6);
      case AppointmentStatus.confirmada:
        return const Color(0xFF10B981);
      case AppointmentStatus.completada:
        return const Color(0xFF8B5CF6);
      case AppointmentStatus.cancelada:
        return const Color(0xFFEF4444);
    }
  }

  IconData _getStatusIcon() {
    switch (appointment.status) {
      case AppointmentStatus.programada:
        return Icons.schedule_rounded;
      case AppointmentStatus.confirmada:
        return Icons.check_circle_rounded;
      case AppointmentStatus.completada:
        return Icons.task_alt_rounded;
      case AppointmentStatus.cancelada:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.person_rounded,
                    title: 'Información del Cliente',
                    children: [
                      _buildInfoRow('Nombre', appointment.fullName),
                      _buildInfoRow('Teléfono', appointment.phoneNumber),
                      _buildInfoRow('Email', appointment.email),
                      _buildInfoRow(
                        'Documento',
                        '${appointment.documentType} ${appointment.documentNumber}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.calendar_month_rounded,
                    title: 'Fecha y Hora',
                    children: [
                      _buildInfoRow(
                        'Fecha',
                        DateFormat('EEEE, d MMMM yyyy', 'es')
                            .format(appointment.appointmentDate),
                      ),
                      _buildInfoRow('Hora', appointment.appointmentTime),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.business_center_rounded,
                    title: 'Servicio',
                    children: [
                      _buildInfoRow('Tipo de servicio', appointment.service),
                      if (appointment.details.isNotEmpty)
                        _buildInfoRow('Detalles', appointment.details),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.info_rounded,
                    title: 'Información Adicional',
                    children: [
                      _buildInfoRow(
                        'Fecha de creación',
                        DateFormat('dd/MM/yyyy HH:mm').format(appointment.createdAt),
                      ),
                      _buildInfoRow(
                        'Última actualización',
                        DateFormat('dd/MM/yyyy HH:mm').format(appointment.updatedAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(), color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Detalles de la Cita',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getStatusColor(), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getStatusIcon(), color: _getStatusColor(), size: 20),
            const SizedBox(width: 8),
            Text(
              appointment.status.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF6B7280),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Cerrar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
