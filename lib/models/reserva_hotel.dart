/// Modelo para ReservaHotelDto (backend: /api/reservas/hotel)
class ReservaHotel {
  final String? idH;
  final String docUsuario;
  final String idHabitacion;
  final String? numeroHabitacion; // lo llena el backend
  final String? tHabitacion; // lo llena el backend
  final double? pNoche; // lo llena el backend
  final String? estHabitacion;
  final DateTime fCheckIn;
  final DateTime fCheckOut;
  final int? noch; // lo calcula el backend
  final double? pTotal; // lo calcula el backend
  final String? estado; // PENDIENTE | CONFIRMADA | CANCELADA | FINALIZADA
  final DateTime? fReserva;

  ReservaHotel({
    this.idH,
    required this.docUsuario,
    required this.idHabitacion,
    this.numeroHabitacion,
    this.tHabitacion,
    this.pNoche,
    this.estHabitacion,
    required this.fCheckIn,
    required this.fCheckOut,
    this.noch,
    this.pTotal,
    this.estado,
    this.fReserva,
  });

  /// Solo enviamos los campos que el backend espera al crear la reserva.
  /// El resto (numeroHabitacion, tHabitacion, pNoche, noches, total) los
  /// calcula y llena el servidor.
  Map<String, dynamic> toJsonCrear() {
    return {
      'docUsuario': docUsuario,
      'idHabitacion': idHabitacion,
      'fCheckIn': fCheckIn.toIso8601String(),
      'fCheckOut': fCheckOut.toIso8601String(),
    };
  }

  factory ReservaHotel.fromJson(Map<String, dynamic> json) {
    return ReservaHotel(
      idH: json['idH']?.toString(),
      docUsuario: json['docUsuario']?.toString() ?? '',
      idHabitacion: json['idHabitacion']?.toString() ?? '',
      numeroHabitacion: json['numeroHabitacion']?.toString(),
      tHabitacion: json['tHabitacion']?.toString(),
      pNoche: json['pNoche'] == null
          ? null
          : (json['pNoche'] as num).toDouble(),
      estHabitacion: json['estHabitacion']?.toString(),
      fCheckIn: DateTime.tryParse(json['fCheckIn']?.toString() ?? '') ??
          DateTime.now(),
      fCheckOut: DateTime.tryParse(json['fCheckOut']?.toString() ?? '') ??
          DateTime.now(),
      noch: json['noch'] == null ? null : int.tryParse('${json['noch']}'),
      pTotal: json['pTotal'] == null
          ? null
          : (json['pTotal'] as num).toDouble(),
      estado: json['estado']?.toString(),
      fReserva: json['fReserva'] == null
          ? null
          : DateTime.tryParse(json['fReserva'].toString()),
    );
  }
}