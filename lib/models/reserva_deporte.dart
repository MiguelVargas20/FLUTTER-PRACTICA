/// Modelo para ReservaDeporteDto (backend: /api/reservas/deporte)
class ReservaDeporte {
  final String? idD;
  final String docUsuario;
  final String tCancha;
  final String? implAlquilados;
  final bool rqrEntrenador;
  final DateTime fInicioReserva;
  final DateTime fFinReserva;
  final double? pr; // lo calcula el backend
  final String? estado;
  final DateTime? fReserva;

  ReservaDeporte({
    this.idD,
    required this.docUsuario,
    required this.tCancha,
    this.implAlquilados,
    required this.rqrEntrenador,
    required this.fInicioReserva,
    required this.fFinReserva,
    this.pr,
    this.estado,
    this.fReserva,
  });

  Map<String, dynamic> toJsonCrear() {
    return {
      'docUsuario': docUsuario,
      'tCancha': tCancha,
      'implAlquilados': implAlquilados ?? '',
      'rqrEntrenador': rqrEntrenador,
      'fInicioReserva': fInicioReserva.toIso8601String(),
      'fFinReserva': fFinReserva.toIso8601String(),
    };
  }

  factory ReservaDeporte.fromJson(Map<String, dynamic> json) {
    return ReservaDeporte(
      idD: json['idD']?.toString(),
      docUsuario: json['docUsuario']?.toString() ?? '',
      tCancha: json['tCancha']?.toString() ?? '',
      implAlquilados: json['implAlquilados']?.toString(),
      rqrEntrenador: json['rqrEntrenador'] == true,
      fInicioReserva:
          DateTime.tryParse(json['fInicioReserva']?.toString() ?? '') ??
              DateTime.now(),
      fFinReserva: DateTime.tryParse(json['fFinReserva']?.toString() ?? '') ??
          DateTime.now(),
      pr: json['pr'] == null ? null : (json['pr'] as num).toDouble(),
      estado: json['estado']?.toString(),
      fReserva: json['fReserva'] == null
          ? null
          : DateTime.tryParse(json['fReserva'].toString()),
    );
  }
}