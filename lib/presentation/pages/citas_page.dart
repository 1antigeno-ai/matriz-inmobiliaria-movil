import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../blocs/appointment_bloc.dart';
import '../../blocs/appointment_event.dart';
import '../../blocs/appointment_state.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointment_repository.dart';
import '../widgets/appointments_calendar_view.dart';
import '../widgets/appointments_list_view.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/create_appointment_dialog.dart';
import '../widgets/edit_appointment_dialog.dart';
import '../widgets/stat_card.dart';
import '../widgets/success_snackbar.dart';
import '../widgets/view_appointment_dialog.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  bool _isCalendarView = true;
  final _searchController = TextEditingController();
  AppointmentStatus? _statusFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(
        AppointmentRepository(Supabase.instance.client),
      )..add(LoadAppointments()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: BlocConsumer<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentOperationSuccess) {
              SuccessSnackbar.show(context, state.message);
            } else if (state is AppointmentError) {
              ErrorSnackbar.show(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppointmentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar las citas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AppointmentBloc>().add(LoadAppointments());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is AppointmentLoaded) {
              return Column(
                children: [
                  _buildHeader(context, state),
                  _buildStatsCards(state),
                  _buildFiltersBar(context, state),
                  Expanded(
                    child: _isCalendarView
                        ? AppointmentsCalendarView(
                            appointments: state.filteredAppointments,
                            onTap: (appointment) => _viewAppointment(context, appointment),
                            onEdit: (appointment) => _editAppointment(context, appointment),
                            onDelete: (appointment) => _deleteAppointment(context, appointment),
                            onStatusChange: (appointment, status) =>
                                _updateStatus(context, appointment, status),
                            onReschedule: (id, date, time) =>
                                _rescheduleAppointment(context, id, date, time),
                          )
                        : AppointmentsListView(
                            appointments: state.filteredAppointments,
                            onTap: (appointment) => _viewAppointment(context, appointment),
                            onEdit: (appointment) => _editAppointment(context, appointment),
                            onDelete: (appointment) => _deleteAppointment(context, appointment),
                            onStatusChange: (appointment, status) =>
                                _updateStatus(context, appointment, status),
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createAppointment(context),
          backgroundColor: const Color(0xFF3B82F6),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Nueva Cita',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppointmentLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 28,
                  color: Color(0xFF3B82F6),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Gestión de Citas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _isCalendarView = !_isCalendarView);
                  },
                  icon: Icon(
                    _isCalendarView ? Icons.list_rounded : Icons.calendar_month_rounded,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                    foregroundColor: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<AppointmentBloc>().add(
                      FilterAppointments(
                        status: _statusFilter,
                        startDate: _startDateFilter,
                        endDate: _endDateFilter,
                        searchQuery: value,
                      ),
                    );
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, teléfono, email...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          context.read<AppointmentBloc>().add(
                                FilterAppointments(
                                  status: _statusFilter,
                                  startDate: _startDateFilter,
                                  endDate: _endDateFilter,
                                ),
                              );
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(AppointmentLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total',
                  count: state.totalCount,
                  color: const Color(0xFF6B7280),
                  icon: Icons.event_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Programadas',
                  count: state.programadaCount,
                  color: const Color(0xFF3B82F6),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Confirmadas',
                  count: state.confirmadaCount,
                  color: const Color(0xFF10B981),
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Completadas',
                  count: state.completadaCount,
                  color: const Color(0xFF8B5CF6),
                  icon: Icons.task_alt_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Canceladas',
                  count: state.canceladaCount,
                  color: const Color(0xFFEF4444),
                  icon: Icons.cancel_rounded,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, AppointmentLoaded state) {
    final hasFilters =
        _statusFilter != null || _startDateFilter != null || _endDateFilter != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Estado',
              icon: Icons.filter_list_rounded,
              isActive: _statusFilter != null,
              onTap: () => _showStatusFilter(context),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Rango de Fechas',
              icon: Icons.date_range_rounded,
              isActive: _startDateFilter != null || _endDateFilter != null,
              onTap: () => _showDateRangeFilter(context),
            ),
            if (hasFilters) ...[
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Limpiar Filtros',
                icon: Icons.clear_rounded,
                isActive: false,
                onTap: () {
                  setState(() {
                    _statusFilter = null;
                    _startDateFilter = null;
                    _endDateFilter = null;
                  });
                  context.read<AppointmentBloc>().add(ClearFilters());
                },
                color: const Color(0xFFEF4444),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (color ?? const Color(0xFF3B82F6))
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? (color ?? const Color(0xFF3B82F6))
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar por Estado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...AppointmentStatus.values.map((status) {
              return ListTile(
                leading: Icon(
                  _statusFilter == status
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _getStatusColor(status),
                ),
                title: Text(status.label),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() => _statusFilter = status);
                  context.read<AppointmentBloc>().add(
                        FilterAppointments(
                          status: status,
                          startDate: _startDateFilter,
                          endDate: _endDateFilter,
                          searchQuery: _searchController.text,
                        ),
                      );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDateRangeFilter(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDateFilter = picked.start;
        _endDateFilter = picked.end;
      });
      context.read<AppointmentBloc>().add(
            FilterAppointments(
              status: _statusFilter,
              startDate: picked.start,
              endDate: picked.end,
              searchQuery: _searchController.text,
            ),
          );
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
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

  void _createAppointment(BuildContext context) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final result = await showDialog<AppointmentModel>(
      context: context,
      builder: (dialogContext) => CreateAppointmentDialog(userId: userId),
    );

    if (result != null && context.mounted) {
      context.read<AppointmentBloc>().add(CreateAppointment(result));
    }
  }

  void _viewAppointment(BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) => ViewAppointmentDialog(appointment: appointment),
    );
  }

  void _editAppointment(BuildContext context, AppointmentModel appointment) async {
    final result = await showDialog<AppointmentModel>(
      context: context,
      builder: (context) => EditAppointmentDialog(appointment: appointment),
    );

    if (result != null && context.mounted) {
      ConfirmationDialog.show(
        context: context,
        title: '¿Guardar cambios?',
        message: '¿Estás seguro de que deseas actualizar esta cita?',
        confirmText: 'Guardar',
        confirmColor: const Color(0xFFF59E0B),
        onConfirm: () {
          context.read<AppointmentBloc>().add(UpdateAppointment(result));
        },
      );
    }
  }

  void _deleteAppointment(BuildContext context, AppointmentModel appointment) {
    ConfirmationDialog.show(
      context: context,
      title: '¿Eliminar cita?',
      message:
          '¿Estás seguro de que deseas eliminar la cita de ${appointment.fullName}? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      onConfirm: () {
        context.read<AppointmentBloc>().add(DeleteAppointment(appointment.id));
      },
    );
  }

  void _updateStatus(
    BuildContext context,
    AppointmentModel appointment,
    AppointmentStatus newStatus,
  ) {
    ConfirmationDialog.show(
      context: context,
      title: '¿Cambiar estado?',
      message:
          '¿Deseas cambiar el estado de la cita a ${newStatus.label.toLowerCase()}?',
      confirmText: 'Confirmar',
      confirmColor: _getStatusColor(newStatus),
      onConfirm: () {
        context.read<AppointmentBloc>().add(
              UpdateAppointmentStatus(appointment.id, newStatus),
            );
      },
    );
  }

  void _rescheduleAppointment(
    BuildContext context,
    String id,
    DateTime newDate,
    String time,
  ) {
    context.read<AppointmentBloc>().add(
          RescheduleAppointment(id, newDate, time),
        );
  }
}
