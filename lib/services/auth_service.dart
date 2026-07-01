import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluuter_aplication_1/utils/api_constants.dart';
import 'package:fluuter_aplication_1/models/login_response.dart';
import 'package:fluuter_aplication_1/models/usuario.dart';

/// Excepción simple para poder mostrar el mensaje real del backend en la UI.
class ApiException implements Exception {
  final String mensaje;
  ApiException(this.mensaje);
  @override
  String toString() => mensaje;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kToken = 'auth_token';
  static const _kUserId = 'auth_user_id';
  static const _kUsername = 'auth_username';
  static const _kNombreCompleto = 'auth_nombre_completo';
  static const _kRoles = 'auth_roles';
  static const _kDocUsuario = 'auth_doc_usuario';

  // ── LOGIN ────────────────────────────────────────────────────
  Future<LoginResponse> login(String username, String password) async {
    late final http.Response response;
    try {
      response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
    } catch (_) {
      throw ApiException('No se pudo conectar al servidor');
    }

    if (response.statusCode == 200) {
      final data = LoginResponse.fromJson(jsonDecode(response.body));
      await _guardarSesion(data);
      // Traemos el perfil completo para obtener el número de documento,
      // que es lo que el backend usa como docUsuario en las reservas.
      await _cargarDocumentoUsuario(data.id, data.token);
      return data;
    }

    throw ApiException(_extraerMensajeError(response, 'Usuario o contraseña incorrectos'));
  }

  Future<void> _guardarSesion(LoginResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, data.token);
    await prefs.setString(_kUserId, data.id);
    await prefs.setString(_kUsername, data.usuario);
    await prefs.setString(_kNombreCompleto, data.nombreCompleto);
    await prefs.setStringList(_kRoles, data.roles);
  }

  Future<void> _cargarDocumentoUsuario(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.perfil(userId)),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final usuario = Usuario.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kDocUsuario, usuario.documento?.numeroD ?? '');
      }
    } catch (_) {
      // Si falla, simplemente no quedará docUsuario cacheado; se puede
      // reintentar más adelante sin bloquear el login.
    }
  }

  // ── REGISTRO ─────────────────────────────────────────────────
  /// [documentoTipo] = "CC" | "TI" | "CE"
  Future<void> registrar({
    required String nombre,
    required String apellido,
    required String documentoTipo,
    required String documentoNumero,
    String? username,
    required String email,
    required String password,
  }) async {
    late final http.Response response;
    try {
      response = await http.post(
        Uri.parse(ApiConstants.registro),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'apellido': apellido,
          // OJO: el backend espera "numeroD", no "numero" (ver modelo Documento.java)
          'documento': {
            'tipo': documentoTipo,
            'numeroD': documentoNumero,
          },
          'username': (username == null || username.trim().isEmpty) ? null : username.trim(),
          'email': email,
          'password': password,
        }),
      );
    } catch (_) {
      throw ApiException('No se pudo conectar al servidor');
    }

    if (response.statusCode == 201) return;

    if (response.statusCode == 409) {
      throw ApiException('El correo o username ya está en uso');
    }

    throw ApiException(_extraerMensajeError(response, 'Datos inválidos, revisa los campos'));
  }

  // ── LOGOUT ───────────────────────────────────────────────────
  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse(ApiConstants.logout),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (_) {
        // Si el backend no responde, igual limpiamos la sesión local.
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ── SESIÓN LOCAL ─────────────────────────────────────────────
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserId);
  }

  Future<String?> getDocUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDocUsuario);
  }

  Future<String?> getNombreCompleto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNombreCompleto);
  }

  Future<List<String>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kRoles) ?? [];
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, String>> authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── HELPER ───────────────────────────────────────────────────
  String _extraerMensajeError(http.Response response, String fallback) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return body['message']?.toString() ??
            body['error']?.toString() ??
            body['mensaje']?.toString() ??
            fallback;
      }
    } catch (_) {
      // el body no era JSON
    }
    return fallback;
  }
}