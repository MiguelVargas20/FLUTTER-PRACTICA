class TipoHabitacion {
  final String? id;
  final String nomTipo;
  final String desc;
  final int cap;

  TipoHabitacion({
    this.id,
    required this.nomTipo,
    required this.desc,
    required this.cap,
  });

  factory TipoHabitacion.fromJson(Map<String, dynamic> json) {
    return TipoHabitacion(
      id: json['id']?.toString(),
      nomTipo: json['nomTipo']?.toString() ?? json['nombreTipoHabitacion']?.toString() ?? '',
      desc: json['desc']?.toString() ?? json['descripcion']?.toString() ?? '',
      cap: (json['cap'] ?? json['capacidadMaxima'] ?? 0) is int
          ? (json['cap'] ?? json['capacidadMaxima'] ?? 0)
          : int.tryParse('${json['cap'] ?? json['capacidadMaxima'] ?? 0}') ?? 0,
    );
  }
}

/// Modelo para HabitacionDto (GET /api/habitaciones, /disponibles, /{id})
class Habitacion {
  final String id;
  final String numeroHabitacion;
  final TipoHabitacion? datosTipoHabitacion;
  final double precioNoche;
  final String estadoHabitacion; // "disponible" | "ocupada" | "mantenimiento"
  final String descripcion;

  Habitacion({
    required this.id,
    required this.numeroHabitacion,
    this.datosTipoHabitacion,
    required this.precioNoche,
    required this.estadoHabitacion,
    required this.descripcion,
  });

  factory Habitacion.fromJson(Map<String, dynamic> json) {
    return Habitacion(
      id: json['id']?.toString() ?? '',
      numeroHabitacion: json['numeroHabitacion']?.toString() ?? '',
      datosTipoHabitacion: json['datosTipoHabitacion'] != null
          ? TipoHabitacion.fromJson(json['datosTipoHabitacion'])
          : null,
      precioNoche: (json['precioNoche'] is num)
          ? (json['precioNoche'] as num).toDouble()
          : double.tryParse('${json['precioNoche']}') ?? 0,
      estadoHabitacion: json['estadoHabitacion']?.toString() ?? 'disponible',
      descripcion: json['descripcion']?.toString() ?? '',
    );
  }
}