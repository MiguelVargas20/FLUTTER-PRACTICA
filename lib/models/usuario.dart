class Documento {
  final String tipo;
  final String numeroD;

  Documento({required this.tipo, required this.numeroD});

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      tipo: json['tipo']?.toString() ?? '',
      numeroD: json['numeroD']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'tipo': tipo, 'numeroD': numeroD};
}

class Direccion {
  final String? cll;
  final String? crr;
  final String? cd;
  final String? ps;

  Direccion({this.cll, this.crr, this.cd, this.ps});

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      cll: json['cll']?.toString(),
      crr: json['crr']?.toString(),
      cd: json['cd']?.toString(),
      ps: json['ps']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'cll': cll, 'crr': crr, 'cd': cd, 'ps': ps};
}

/// Modelo para UsuarioDto (GET /api/usuarios/perfil/{id})
class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final Documento? documento;
  final String? telefono;
  final String email;
  final Direccion? direccion;
  final String? fechaNacimiento;
  final String? estado;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.documento,
    this.telefono,
    required this.email,
    this.direccion,
    this.fechaNacimiento,
    this.estado,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      documento: json['documento'] != null
          ? Documento.fromJson(json['documento'])
          : null,
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString() ?? '',
      direccion:
          json['direccion'] != null ? Direccion.fromJson(json['direccion']) : null,
      fechaNacimiento: json['fechaNacimiento']?.toString(),
      estado: json['estado']?.toString(),
    );
  }

  String get nombreCompleto => '$nombre $apellido';
}