import 'package:flutter/material.dart';
import '../../data/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(AppointmentStatus) onStatusChange;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getStatusColor().withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: _getStatusColor(),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.service,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusMenu(context),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  appointment.appointmentTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.phone_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  appointment.phoneNumber,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusBadge(),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  color: const Color(0xFFF59E0B),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B).withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_rounded, size: 20),
                  color: const Color(0xFFEF4444),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), size: 14, color: _getStatusColor()),
          const SizedBox(width: 6),
          Text(
            appointment.status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMenu(BuildContext context) {
    return PopupMenuButton<AppointmentStatus>(
      icon: Icon(Icons.more_vert_rounded, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        _buildStatusMenuItem(
          AppointmentStatus.programada,
          Icons.schedule_rounded,
          const Color(0xFF3B82F6),
        ),
        _buildStatusMenuItem(
          AppointmentStatus.confirmada,
          Icons.check_circle_rounded,
          const Color(0xFF10B981),
        ),
        _buildStatusMenuItem(
          AppointmentStatus.completada,
          Icons.task_alt_rounded,
          const Color(0xFF8B5CF6),
        ),
        _buildStatusMenuItem(
          AppointmentStatus.cancelada,
          Icons.cancel_rounded,
          const Color(0xFFEF4444),
        ),
      ],
      onSelected: (status) {
        if (status != appointment.status) {
          onStatusChange(status);
        }
      },
    );
  }

  PopupMenuItem<AppointmentStatus> _buildStatusMenuItem(
    AppointmentStatus status,
    IconData icon,
    Color color,
  ) {
    final isSelected = appointment.status == status;
    return PopupMenuItem<AppointmentStatus>(
      value: status,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            status.label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, color: color, size: 18),
          ],
        ],
      ),
    );
  }
}
