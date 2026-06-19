import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluuter_aplication_1/registro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool ocultarPassword = true;
  bool cargando = false; // ← NUEVO: controla el spinner

  static const Color dorado = Color(0xFFD4AF37);
  static const Color doradoOscuro = Color(0xFF8B732A);
  static const Color fondoGris = Color(0xFFF9F9F9);

  // ── CAMBIA ESTO por la IP de tu backend ───────────────────────────
  // Emulador Android  → 'http://10.0.2.2:8080'
  // Dispositivo físico → 'http://192.168.X.X:8080'  (IP de tu PC en la red)
  // Web/Desktop       → 'http://localhost:8080'
  static const String baseUrl = 'http://localhost:8080';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── FUNCIÓN DE LOGIN ───────────────────────────────────────────────
  Future<void> login() async {
    // Validación básica antes de llamar al backend
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _mostrarSnackbar('Por favor completa todos los campos', esError: true);
      return;
    }

    setState(() => cargando = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': emailController.text.trim(),       // ajusta la clave según tu API
          'password': passwordController.text.trim(),  // ej: 'contrasena', 'password'
        }),
      );

      if (response.statusCode == 200) {
        // ── Login exitoso ──────────────────────────────────────────
        final Map<String, dynamic> datos = jsonDecode(response.body);

        // Guarda el token y el nombre para usarlos en otras pantallas
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', datos['token']);
        await prefs.setString('nombre', datos['nombreCompleto'] ?? '');
        // Si tu backend devuelve el rol: await prefs.setString('rol', datos['rol']);

        _mostrarSnackbar('¡Bienvenido!', esError: false);

        // Navega al Home y elimina el Login del stack
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const Home()),
        // );

      } else if (response.statusCode == 401) {
        _mostrarSnackbar('Correo o contraseña incorrectos', esError: true);

      } else {
        _mostrarSnackbar('Error del servidor (${response.statusCode})', esError: true);
      }

    } catch (e) {
      // Error de red: backend apagado, IP incorrecta, sin internet, etc.
      _mostrarSnackbar('No se pudo conectar al servidor', esError: true);
    } finally {
      // finally siempre se ejecuta, con éxito o con error
      setState(() => cargando = false);
    }
  }

  void _mostrarSnackbar(String mensaje, {required bool esError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(fontFamily: 'Montserrat'),
        ),
        backgroundColor: esError ? Colors.red[400] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoGris,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBrandHeader(),
                const SizedBox(height: 30),

                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Bienvenido de nuevo',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Ingresa para gestionar tus reservas',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500], fontFamily: 'Montserrat'),
                        ),
                      ),

                      const SizedBox(height: 28),

                      _buildLabel('Correo electrónico'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: emailController,
                        hint: 'nombre@ejemplo.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('Contraseña'),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: dorado, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: passwordController,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscure: ocultarPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            ocultarPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          onPressed: () => setState(() => ocultarPassword = !ocultarPassword),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── BOTÓN — ahora llama a login() ─────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // Si está cargando, deshabilita el botón (null = deshabilitado)
                          onPressed: cargando ? null : login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dorado,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: dorado.withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          // Spinner o texto según el estado
                          child: cargando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'INICIAR SESIÓN',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      _buildDivider('O CONTINUAR CON'),
                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(child: _buildSocialButton(icon: Icons.g_mobiledata_rounded, label: 'Google', onPressed: () {})),
                          const SizedBox(width: 10),
                          Expanded(child: _buildSocialButton(icon: Icons.apple_rounded, label: 'Apple', onPressed: () {})),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¿No tienes una cuenta? ', style: TextStyle(color: Colors.grey[600], fontSize: 13, fontFamily: 'Montserrat')),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())),
                              child: const Text(
                                'Regístrate',
                                style: TextStyle(color: dorado, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── WIDGETS HELPERS (sin cambios) ──────────────────────────────────

  Widget _buildBrandHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: dorado, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.hotel_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        const Text('GOLDENBOOKING', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: doradoOscuro, letterSpacing: 0.5, fontFamily: 'Montserrat')),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey[700], fontFamily: 'Montserrat'));

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData prefixIcon, bool obscure = false, Widget? suffixIcon, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller, obscureText: obscure, keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
      decoration: InputDecoration(
        hintText: hint, hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(prefixIcon, size: 18, color: Colors.grey[400]),
        suffixIcon: suffixIcon, filled: true, fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: dorado, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, VoidCallback onPressed) {
    return SizedBox(width: double.infinity, height: 50,
      child: ElevatedButton(onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: dorado, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 0.8)),
      ),
    );
  }

  Widget _buildDivider(String text) {
    return Row(children: [
      Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(text, style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
      ),
      Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
    ]);
  }

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(onPressed: onPressed,
      icon: Icon(icon, color: dorado, size: 22),
      label: Text(label, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[700], side: BorderSide(color: Colors.grey[200]!), padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 8))],
    border: Border.all(color: Colors.black.withOpacity(0.05)),
  );

  Widget _buildFooter() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [_footerLink('Privacidad'), _footerSep(), _footerLink('Términos'), _footerSep(), _footerLink('Soporte')]);
  Widget _footerLink(String text) => Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 11, fontFamily: 'Montserrat'));
  Widget _footerSep() => Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('|', style: TextStyle(color: Colors.grey[300], fontSize: 11)));
}