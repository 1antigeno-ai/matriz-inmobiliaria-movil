# Sistema de Gestión de Citas - Instrucciones de Uso

## Instalación de Dependencias

Para instalar las dependencias del proyecto, ejecuta:

```bash
flutter pub get
```

## Ejecución del Proyecto

Para ejecutar el proyecto en modo desarrollo:

```bash
flutter run
```

## Funcionalidades Implementadas

### 1. Vista de Citas con Calendario
- Calendario interactivo que muestra las citas del mes
- Vista por día con las citas programadas
- Arrastrar y soltar citas para reagendar (drag & drop)
- Indicadores visuales de citas en el calendario

### 2. Vista de Lista
- Listado completo de todas las citas
- Cambio fácil entre vista de calendario y lista
- Botón en el header para alternar vistas

### 3. Creación de Citas (Multi-paso)
**Paso 1: Información del Cliente**
- Nombre completo (validado)
- Número de teléfono (10 dígitos, solo números)
- Correo electrónico (validado)
- Tipo de documento (CC, TI, CE, Pasaporte)
- Número de documento

**Paso 2: Fecha y Hora**
- Selector de fecha con calendario
- Selector de hora
- Interfaz visual atractiva

**Paso 3: Servicio y Detalles**
- Tipo de servicio
- Detalles adicionales (opcional)
- Estado inicial (Programada o Confirmada)

### 4. Edición de Citas
- Formulario compacto con todos los campos
- Actualización rápida sin pasos
- Validación completa

### 5. Visualización de Citas
- Modal con toda la información
- Diseño organizado por secciones
- Códigos de color según estado

### 6. Cambio Rápido de Estado
- Menú desplegable en cada tarjeta de cita
- Estados disponibles:
  - Programada (azul)
  - Confirmada (verde)
  - Completada (morado)
  - Cancelada (rojo)

### 7. Alertas de Confirmación
- Confirmación antes de eliminar
- Confirmación antes de editar
- Confirmación antes de cambiar estado
- Mensajes claros y concisos

### 8. Notificaciones
- Éxito al crear cita
- Éxito al actualizar cita
- Éxito al eliminar cita
- Éxito al cambiar estado
- Errores con mensajes descriptivos

### 9. Filtros y Búsqueda
**Filtros:**
- Por estado (Programada, Confirmada, Completada, Cancelada)
- Por rango de fechas
- Botón para limpiar filtros

**Búsqueda:**
- Barra de búsqueda en tiempo real
- Busca por: nombre, teléfono, email, documento, servicio

### 10. Tarjetas de Estadísticas
- Total de citas
- Citas programadas
- Citas confirmadas
- Citas completadas
- Citas canceladas

### 11. Diseño Mobile-First
- Optimizado para dispositivos móviles
- Scroll mínimo
- Interfaz intuitiva y cómoda
- Elementos táctiles de buen tamaño

## Arquitectura del Proyecto

```
lib/
├── blocs/
│   ├── appointment_bloc.dart
│   ├── appointment_event.dart
│   └── appointment_state.dart
├── data/
│   ├── models/
│   │   └── appointment_model.dart
│   └── repositories/
│       └── appointment_repository.dart
├── presentation/
│   ├── pages/
│   │   └── citas_page.dart
│   └── widgets/
│       ├── appointment_card.dart
│       ├── appointments_calendar_view.dart
│       ├── appointments_list_view.dart
│       ├── confirmation_dialog.dart
│       ├── create_appointment_dialog.dart
│       ├── custom_dropdown.dart
│       ├── custom_text_field.dart
│       ├── edit_appointment_dialog.dart
│       ├── stat_card.dart
│       ├── success_snackbar.dart
│       └── view_appointment_dialog.dart
└── main.dart
```

## Base de Datos (Supabase)

### Tabla: appointments
- **id**: UUID (Primary Key)
- **full_name**: Text (Nombre completo)
- **phone_number**: Text (Teléfono)
- **email**: Text (Email)
- **document_type**: Text (Tipo de documento)
- **document_number**: Text (Número de documento)
- **appointment_date**: Date (Fecha de la cita)
- **appointment_time**: Time (Hora de la cita)
- **service**: Text (Servicio solicitado)
- **details**: Text (Detalles adicionales)
- **status**: Text (Estado: programada, confirmada, completada, cancelada)
- **created_at**: Timestamp (Fecha de creación)
- **updated_at**: Timestamp (Última actualización)
- **user_id**: UUID (Referencia al usuario)

### Seguridad (RLS)
- Row Level Security habilitado
- Los usuarios solo pueden ver/editar sus propias citas
- Políticas para SELECT, INSERT, UPDATE, DELETE

## Validaciones Implementadas

1. **Nombre completo**: Requerido
2. **Teléfono**: Requerido, 10 dígitos, solo números
3. **Email**: Requerido, formato válido
4. **Tipo de documento**: Requerido
5. **Número de documento**: Requerido, solo números
6. **Fecha**: Requerida, no puede ser en el pasado
7. **Hora**: Requerida
8. **Servicio**: Requerido

## Colores y Diseño

### Paleta de Colores:
- **Programada**: Azul (#3B82F6)
- **Confirmada**: Verde (#10B981)
- **Completada**: Morado (#8B5CF6)
- **Cancelada**: Rojo (#EF4444)
- **Primario**: Azul (#3B82F6)
- **Advertencia**: Ámbar (#F59E0B)
- **Texto**: Gris oscuro (#1F2937)

### Características de Diseño:
- Bordes redondeados (12-16px)
- Sombras suaves
- Espaciado consistente (8px system)
- Tipografía clara y legible
- Iconos de Material Design

## Navegación y UX

1. **Navegación intuitiva**: Todo accesible en 2-3 toques
2. **Feedback visual**: Animaciones y transiciones suaves
3. **Estados de carga**: Indicadores de progreso
4. **Mensajes claros**: Errores y éxitos bien comunicados
5. **Confirmaciones**: Acciones destructivas requieren confirmación
6. **Accesibilidad**: Tamaños de toque adecuados (mínimo 44px)

## Características Avanzadas

1. **Drag & Drop**: Arrastra citas en el calendario para reagendar
2. **Búsqueda en tiempo real**: Resultados instantáneos
3. **Filtros múltiples**: Combina varios filtros
4. **Formulario multi-paso**: Proceso guiado de creación
5. **Actualizaciones automáticas**: BLoC maneja el estado eficientemente
6. **Persistencia**: Todos los datos se guardan en Supabase

## Notas Técnicas

- **Estado**: Gestionado con BLoC pattern
- **Base de datos**: Supabase (PostgreSQL)
- **Calendario**: table_calendar package
- **Localización**: Español (es_ES)
- **Validaciones**: En tiempo real y al enviar
- **Responsive**: Adaptado a diferentes tamaños de pantalla

## Próximas Mejoras Sugeridas

1. Notificaciones push para recordatorios
2. Sincronización con calendarios del dispositivo
3. Exportar citas a PDF
4. Filtro por rango de horas
5. Vista de agenda semanal
6. Reportes y estadísticas avanzadas
