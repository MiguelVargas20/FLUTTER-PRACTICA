/// ─────────────────────────────────────────────────────────────
/// Configuración central de la API — GOLDENBOOKING
/// Todas las rutas coinciden EXACTAMENTE con los @RequestMapping
/// del backend (Spring Boot, GOLDEN-BOOKING-BACKEND).
/// ─────────────────────────────────────────────────────────────
class ApiConstants {
  ApiConstants._();

  // ── Host base ────────────────────────────────────────────────
  // Emulador Android            → 'http://10.0.2.2:8080'
  // Dispositivo físico / Wi-Fi  → 'http://192.168.X.X:8080'  (IP de tu PC)
  // Chrome / Flutter Web        → 'http://localhost:8080'
  // iOS Simulator                → 'http://localhost:8080'
  static const String baseUrl = 'http://localhost:8080';

  // ── Auth (OJO: NO llevan /api, van directo en /auth) ───────────
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String recuperarPassword = '$baseUrl/auth/recuperar-password';

  // ── Usuarios ────────────────────────────────────────────────
  static const String registro = '$baseUrl/api/usuarios/registro';
  static String perfil(String id) => '$baseUrl/api/usuarios/perfil/$id';
  static String usuarioPorDoc(String docNum) => '$baseUrl/api/usuarios/doc/$docNum';

  // ── Habitaciones ────────────────────────────────────────────
  static const String habitaciones = '$baseUrl/api/habitaciones';
  static const String habitacionesDisponibles = '$baseUrl/api/habitaciones/disponibles';
  static String habitacionPorId(String id) => '$baseUrl/api/habitaciones/$id';

  // ── Tipos de habitación ─────────────────────────────────────
  static const String tiposHabitacion = '$baseUrl/api/tipohabitaciones';

  // ── Reservas de hotel ───────────────────────────────────────
  static const String reservasHotel = '$baseUrl/api/reservas/hotel';
  static const String misReservasHotel = '$baseUrl/api/reservas/hotel/mis-reservas';
  static String cancelarReservaHotel(String id) => '$baseUrl/api/reservas/hotel/$id/cancelar';

  // ── Reservas de deporte ─────────────────────────────────────
  static const String reservasDeporte = '$baseUrl/api/reservas/deporte';
  static const String misReservasDeporte = '$baseUrl/api/reservas/deporte/mis-reservas';
  static String cancelarReservaDeporte(String id) => '$baseUrl/api/reservas/deporte/$id/cancelar';

  // ── Contacto ────────────────────────────────────────────────
  static const String contacto = '$baseUrl/api/contacto';
}