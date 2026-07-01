import 'package:flutter/material.dart';
import 'package:fluuter_aplication_1/screens/home.dart';
import 'package:fluuter_aplication_1/screens/registro.dart';
import 'package:fluuter_aplication_1/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool ocultarPassword = true;
  bool cargando = false;

  static const Color dorado = Color(0xFFD4AF37);
  static const Color doradoOscuro = Color(0xFF8B732A);
  static const Color fondoGris = Color(0xFFF9F9F9);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── FUNCIÓN DE LOGIN — ahora usa AuthService (fuente única de verdad) ──
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      // AuthService.login ya guarda token, id, usuario, nombreCompleto,
      // roles Y el docUsuario (necesario para las reservas) con las
      // MISMAS keys que usan HabitacionService y ReservaService.
      await AuthService.instance.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      _mostrarSnackbar('¡Bienvenido!', esError: false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on ApiException catch (e) {
      _mostrarSnackbar(e.mensaje, esError: true);
    } catch (e) {
      _mostrarSnackbar('No se pudo conectar al servidor', esError: true);
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoGris,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Form(
              key: _formKey,
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
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
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
                        _buildLabel('Nombre de usuario'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: emailController,
                          hint: 'juan.perez',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Ingresa tu usuario' : null,
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
                          validator: (value) => (value == null || value.length < 4) ? 'Contraseña muy corta' : null,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: cargando ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dorado,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: dorado.withValues(alpha: 0.6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: cargando
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : const Text(
                                    'INICIAR SESIÓN',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 0.8),
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
      ),
    );
  }

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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
      decoration: InputDecoration(
        hintText: hint, hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(prefixIcon, size: 18, color: Colors.grey[400]),
        suffixIcon: suffixIcon, filled: true, fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: dorado, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 8))],
    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
  );

  Widget _buildFooter() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [_footerLink('Privacidad'), _footerSep(), _footerLink('Términos'), _footerSep(), _footerLink('Soporte')]);
  Widget _footerLink(String text) => Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 11, fontFamily: 'Montserrat'));
  Widget _footerSep() => Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('|', style: TextStyle(color: Colors.grey[300], fontSize: 11)));
}