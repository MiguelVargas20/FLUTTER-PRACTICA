import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluuter_aplication_1/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDocController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? tipoDocSeleccionado;
  bool ocultarPassword = true;
  bool aceptaTerminos = false;
  bool cargando = false;
  int currentStep = 1;

  static const Color dorado = Color(0xFFD4AF37);
  static const Color doradoOscuro = Color(0xFF8B732A);
  static const Color fondoGris = Color(0xFFF9F9F9);

  // ── Misma baseUrl que el Login ─────────────────────────────────────
  // Emulador Android  → 'http://10.0.2.2:8080'
  // Dispositivo físico → 'http://192.168.X.X:8080'
  static const String baseUrl = 'http://localhost:8080';

  final List<Map<String, String>> tiposDocumento = [
    {'value': 'CC', 'label': 'Cédula de ciudadanía'},
    {'value': 'TI', 'label': 'Tarjeta de identidad'},
    {'value': 'CE', 'label': 'Cédula de extranjería'},
  ];

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    numeroDocController.dispose();
    usernameController.dispose(); 
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── FUNCIÓN REGISTRO ───────────────────────────────────────────────
  Future<void> registrar() async {
    // 1. Validaciones antes de tocar el backend
    if (nombreController.text.trim().isEmpty ||
        apellidoController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        numeroDocController.text.trim().isEmpty ||
        tipoDocSeleccionado == null) {
      _mostrarSnackbar('Por favor completa todos los campos obligatorios', esError: true);
      return;
    }

    if (!aceptaTerminos) {
      _mostrarSnackbar('Debes aceptar los términos y condiciones', esError: true);
      return;
    }

    setState(() => cargando = true);

    try {
      // 2. Armamos el JSON que espera UsuarioRegistroDto
      //    Documento es un objeto anidado: { "tipo": "CC", "numero": "123" }
      final Map<String, dynamic> body = {
        "nombre": nombreController.text.trim(),
        "apellido": apellidoController.text.trim(),
        "documento": {
          "tipo": tipoDocSeleccionado,        // "CC", "TI" o "CE"
          "numero": numeroDocController.text.trim(),
        },
        "username": usernameController.text.trim().isEmpty
            ? null                             // username es opcional en tu DTO
            : usernameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        // telefono, direccion, fechaNacimiento, estado, roles → opcionales
        // los puedes agregar aquí si los necesitas en el registro
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/usuarios/registro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // 3. Tu backend devuelve 201 CREATED cuando todo sale bien
      if (response.statusCode == 201) {
        _mostrarSnackbar('¡Cuenta creada exitosamente!', esError: false);

        // Espera un momento para que el usuario lea el mensaje
        await Future.delayed(const Duration(seconds: 1));

        // Lleva al Login y limpia el stack de navegación
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
          );
        }

      } else if (response.statusCode == 400) {
        // Spring devuelve 400 cuando falla @Valid
        // Intentamos leer el mensaje de error del body
        final Map<String, dynamic> error = jsonDecode(response.body);
        final String mensaje = error['message'] ??
            error['error'] ??
            'Datos inválidos, revisa los campos';
        _mostrarSnackbar(mensaje, esError: true);

      } else if (response.statusCode == 409) {
        // Conflict: email o username ya registrado
        _mostrarSnackbar('El correo o username ya está en uso', esError: true);

      } else {
        _mostrarSnackbar(
          'Error del servidor (${response.statusCode})',
          esError: true,
        );
      }
    } catch (e) {
      // Sin conexión, backend apagado, IP incorrecta, etc.
      _mostrarSnackbar('No se pudo conectar al servidor', esError: true);
    } finally {
      // Siempre se ejecuta, con éxito o con error
      if (mounted) setState(() => cargando = false);
    }
  }

  void _mostrarSnackbar(String mensaje, {required bool esError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(fontFamily: 'Montserrat')),
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
              children: [
                _buildBrandHeader(),
                const SizedBox(height: 28),

                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Crea tu cuenta',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Completa los datos para comenzar',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500], fontFamily: 'Montserrat'),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildStepIndicator(currentStep),
                      const SizedBox(height: 24),

                      // Nombre + Apellido
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              label: 'Nombre *',
                              child: _buildTextField(controller: nombreController, hint: 'Juan', prefixIcon: Icons.person_outline_rounded),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildLabeledField(
                              label: 'Apellido *',
                              child: _buildTextField(controller: apellidoController, hint: 'Perez', prefixIcon: Icons.badge_outlined),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Tipo doc + Número doc
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildLabeledField(label: 'Tipo doc. *', child: _buildDropdown()),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: _buildLabeledField(
                              label: 'N° documento *',
                              child: _buildTextField(controller: numeroDocController, hint: '123456789', prefixIcon: Icons.numbers_rounded, keyboardType: TextInputType.number),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _buildLabeledField(
                        label: 'Username',
                        child: _buildTextField(controller: usernameController, hint: '@juan_perez (opcional)', prefixIcon: Icons.alternate_email_rounded),
                      ),

                      const SizedBox(height: 14),

                      _buildLabeledField(
                        label: 'Correo electrónico *',
                        child: _buildTextField(controller: emailController, hint: 'nombre@ejemplo.com', prefixIcon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
                      ),

                      const SizedBox(height: 14),

                      _buildLabeledField(
                        label: 'Contraseña *',
                        child: _buildTextField(
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
                      ),

                      // Barra fortaleza contraseña
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          passwordController.addListener(() => setLocalState(() {}));
                          return _buildPasswordStrength(passwordController.text);
                        },
                      ),

                      const SizedBox(height: 18),

                      // Checkbox términos
                      GestureDetector(
                        onTap: () => setState(() => aceptaTerminos = !aceptaTerminos),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: aceptaTerminos ? dorado : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: aceptaTerminos ? dorado : Colors.grey[300]!, width: 1.5),
                              ),
                              child: aceptaTerminos ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Montserrat', height: 1.5),
                                  children: const [
                                    TextSpan(text: 'Acepto los '),
                                    TextSpan(text: 'Términos de servicio', style: TextStyle(color: dorado, fontWeight: FontWeight.w600)),
                                    TextSpan(text: ' y la '),
                                    TextSpan(text: 'Política de privacidad', style: TextStyle(color: dorado, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── BOTÓN — llama a registrar() ───────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: cargando ? null : registrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dorado,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: dorado.withOpacity(0.6),
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
                                  'CREAR CUENTA',
                                  style: TextStyle(fontSize: 14, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 0.8),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¿Ya tienes una cuenta? ', style: TextStyle(color: Colors.grey[600], fontSize: 13, fontFamily: 'Montserrat')),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Login())),
                              child: const Text('Inicia sesión', style: TextStyle(color: dorado, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Montserrat')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text('© 2026 GOLDENBOOKING. Todos los derechos reservados.', style: TextStyle(color: Colors.grey[400], fontSize: 11, fontFamily: 'Montserrat')),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── WIDGETS INTERNOS ───────────────────────────────────────────────

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

  Widget _buildStepIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 3; i++) ...[
          _buildStep(i, currentStep),
          if (i < 3)
            Container(width: 32, height: 1, color: i < currentStep ? dorado : Colors.grey[200]),
        ],
      ],
    );
  }

  Widget _buildStep(int step, int current) {
    final bool done = step < current;
    final bool active = step == current;
    return Container(
      width: 26, height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? dorado : Colors.transparent,
        border: Border.all(color: (done || active) ? dorado : Colors.grey[300]!, width: done ? 0 : 1.5),
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check, size: 13, color: Colors.white)
            : Text('$step', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', color: active ? dorado : Colors.grey[400])),
      ),
    );
  }

  Widget _buildPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) strength++;

    final colors = [Colors.red, Colors.orange, dorado, Colors.green];
    final labels = ['Débil', 'Regular', 'Buena', 'Fuerte'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: i < strength ? colors[strength - 1] : Colors.grey[200],
              ),
            ),
          )),
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(labels[strength > 0 ? strength - 1 : 0],
            style: TextStyle(fontSize: 11, fontFamily: 'Montserrat', color: strength > 0 ? colors[strength - 1] : Colors.grey)),
        ],
      ],
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey[700], fontFamily: 'Montserrat')),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
        prefixIcon: Icon(prefixIcon, size: 17, color: Colors.grey[400]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: dorado, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: tipoDocSeleccionado,
      hint: Text('CC / TI', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.assignment_ind_outlined, size: 17, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: dorado, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      ),
      items: tiposDocumento.map((tipo) => DropdownMenuItem<String>(
        value: tipo['value'],
        child: Text(tipo['value']!, style: const TextStyle(fontFamily: 'Montserrat')),
      )).toList(),
      onChanged: (value) => setState(() => tipoDocSeleccionado = value),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 8))],
      border: Border.all(color: Colors.black.withOpacity(0.05)),
    );
  }
}