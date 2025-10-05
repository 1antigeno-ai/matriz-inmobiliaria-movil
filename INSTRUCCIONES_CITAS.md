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

## Almacenamiento de Datos (Local Storage)

### Tecnología: SharedPreferences
Los datos se almacenan **localmente en el dispositivo** utilizando SharedPreferences, que:
- Persiste los datos entre sesiones de la aplicación
- Es específico para cada dispositivo
- No requiere conexión a internet
- Es rápido y eficiente

### Ventajas del Almacenamiento Local

1. **Sin dependencias externas**: No requiere servidor ni base de datos
2. **Funcionamiento offline**: La app funciona sin conexión a internet
3. **Rápido**: Acceso instantáneo a los datos
4. **Privado**: Los datos se quedan en el dispositivo
5. **Simple**: Fácil de implementar y mantener

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

## Dependencias del Proyecto

```yaml
dependencies:
  flutter_bloc: ^8.1.3         # Gestión de estado
  equatable: ^2.0.5            # Comparación de objetos
  intl: ^0.19.0                # Internacionalización y formato de fechas
  table_calendar: ^3.1.2       # Calendario interactivo
  shared_preferences: ^2.2.2   # Almacenamiento local
  uuid: ^4.3.3                 # Generación de IDs únicos
```

## Colores y Diseño

### Paleta de Colores:
- **Programada**: Azul (#3B82F6)
- **Confirmada**: Verde (#10B981)
- **Completada**: Morado (#8B5CF6)
- **Cancelada**: Rojo (#EF4444)
- **Primario**: Azul (#3B82F6)
- **Advertencia**: Ámbar (#F59E0B)
- **Texto**: Gris oscuro (#1F2937)

## Notas Importantes

- **Almacenamiento**: Todos los datos se guardan localmente en el dispositivo
- **Offline**: La aplicación funciona completamente sin conexión a internet
- **Privacidad**: Los datos no se comparten con ningún servidor
- **Persistencia**: Los datos permanecen guardados entre sesiones
