import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_card.dart';

class AppointmentsCalendarView extends StatefulWidget {
  final List<AppointmentModel> appointments;
  final Function(AppointmentModel) onTap;
  final Function(AppointmentModel) onEdit;
  final Function(AppointmentModel) onDelete;
  final Function(AppointmentModel, AppointmentStatus) onStatusChange;
  final Function(String, DateTime, String) onReschedule;

  const AppointmentsCalendarView({
    super.key,
    required this.appointments,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
    required this.onReschedule,
  });

  @override
  State<AppointmentsCalendarView> createState() => _AppointmentsCalendarViewState();
}

class _AppointmentsCalendarViewState extends State<AppointmentsCalendarView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    return widget.appointments.where((appointment) {
      return isSameDay(appointment.appointmentDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            locale: 'es_ES',
            startingDayOfWeek: StartingDayOfWeek.monday,
            eventLoader: _getAppointmentsForDay,
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.event_rounded, size: 20, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                'Citas del ${DateFormat('d MMMM yyyy', 'es').format(_selectedDay)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _buildAppointmentsList(),
        ),
      ],
    );
  }

  Widget _buildAppointmentsList() {
    final dayAppointments = _getAppointmentsForDay(_selectedDay);

    if (dayAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay citas programadas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'para este día',
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dayAppointments.length,
      itemBuilder: (context, index) {
        final appointment = dayAppointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Draggable<AppointmentModel>(
            data: appointment,
            feedback: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                child: Opacity(
                  opacity: 0.8,
                  child: AppointmentCard(
                    appointment: appointment,
                    onTap: () {},
                    onEdit: () {},
                    onDelete: () {},
                    onStatusChange: (status) {},
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: AppointmentCard(
                appointment: appointment,
                onTap: () {},
                onEdit: () {},
                onDelete: () {},
                onStatusChange: (status) {},
              ),
            ),
            child: DragTarget<AppointmentModel>(
              onWillAccept: (data) => data != appointment,
              onAccept: (draggedAppointment) {
                _showRescheduleDialog(draggedAppointment, _selectedDay);
              },
              builder: (context, candidateData, rejectedData) {
                return AppointmentCard(
                  appointment: appointment,
                  onTap: () => widget.onTap(appointment),
                  onEdit: () => widget.onEdit(appointment),
                  onDelete: () => widget.onDelete(appointment),
                  onStatusChange: (status) => widget.onStatusChange(appointment, status),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showRescheduleDialog(AppointmentModel appointment, DateTime newDate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reagendar Cita'),
        content: Text(
          '¿Deseas mover la cita de ${appointment.fullName} al ${DateFormat('d MMMM yyyy', 'es').format(newDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onReschedule(
                appointment.id,
                newDate,
                appointment.appointmentTime,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
