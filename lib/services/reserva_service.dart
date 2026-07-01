import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluuter_aplication_1/utils/api_constants.dart';
import 'package:fluuter_aplication_1/models/reserva_hotel.dart';
import 'package:fluuter_aplication_1/models/reserva_deporte.dart';
import 'package:fluuter_aplication_1/services/auth_service.dart';

class ReservaService {
  ReservaService._();
  static final ReservaService instance = ReservaService._();

  // ── HOTEL ────────────────────────────────────────────────────
  Future<ReservaHotel> crearReservaHotel(ReservaHotel reserva) async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.post(
      Uri.parse(ApiConstants.reservasHotel),
      headers: headers,
      body: jsonEncode(reserva.toJsonCrear()),
    );

    if (response.statusCode == 201) {
      return ReservaHotel.fromJson(jsonDecode(response.body));
    }
    throw ApiException(_extraerMensaje(response, 'No se pudo crear la reserva de hotel'));
  }

  Future<List<ReservaHotel>> misReservasHotel() async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.get(
      Uri.parse(ApiConstants.misReservasHotel),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReservaHotel.fromJson(e)).toList();
    }
    throw ApiException('No se pudieron cargar tus reservas de hotel');
  }

  Future<void> cancelarReservaHotel(String id) async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.patch(
      Uri.parse(ApiConstants.cancelarReservaHotel(id)),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw ApiException(_extraerMensaje(response, 'No se pudo cancelar la reserva'));
    }
  }

  // ── DEPORTE ──────────────────────────────────────────────────
  Future<ReservaDeporte> crearReservaDeporte(ReservaDeporte reserva) async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.post(
      Uri.parse(ApiConstants.reservasDeporte),
      headers: headers,
      body: jsonEncode(reserva.toJsonCrear()),
    );

    if (response.statusCode == 201) {
      return ReservaDeporte.fromJson(jsonDecode(response.body));
    }
    throw ApiException(_extraerMensaje(response, 'No se pudo crear la reserva deportiva'));
  }

  Future<List<ReservaDeporte>> misReservasDeporte() async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.get(
      Uri.parse(ApiConstants.misReservasDeporte),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReservaDeporte.fromJson(e)).toList();
    }
    throw ApiException('No se pudieron cargar tus reservas deportivas');
  }

  Future<void> cancelarReservaDeporte(String id) async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.patch(
      Uri.parse(ApiConstants.cancelarReservaDeporte(id)),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw ApiException(_extraerMensaje(response, 'No se pudo cancelar la reserva'));
    }
  }

  // ── HELPER ───────────────────────────────────────────────────
  String _extraerMensaje(http.Response response, String fallback) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return body['message']?.toString() ??
            body['error']?.toString() ??
            fallback;
      }
    } catch (_) {}
    return fallback;
  }
}