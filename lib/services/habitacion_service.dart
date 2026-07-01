import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluuter_aplication_1/utils/api_constants.dart';
import 'package:fluuter_aplication_1/models/habitacion.dart';
import 'package:fluuter_aplication_1/services/auth_service.dart';

class HabitacionService {
  HabitacionService._();
  static final HabitacionService instance = HabitacionService._();

  /// GET /api/habitaciones/disponibles
  Future<List<Habitacion>> listarDisponibles() async {
    final headers = await AuthService.instance.authHeaders();
    final response = await http.get(
      Uri.parse(ApiConstants.habitacionesDisponibles),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Habitacion.fromJson(e)).toList();
    }

    throw ApiException('No se pudieron cargar las habitaciones disponibles');
  }
}