class LoginResponse {
  final String token;
  final String id;
  final String usuario;
  final String nombreCompleto;
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.id,
    required this.usuario,
    required this.nombreCompleto,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      id: json['id'] ?? '',
      usuario: json['usuario'] ?? json['username'] ?? '',
      nombreCompleto: json['nombreCompleto'] ?? '',
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : <String>[],
    );
  }
}