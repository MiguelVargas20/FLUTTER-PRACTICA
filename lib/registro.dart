import 'package:flutter/material.dart';
import 'package:fluuter_aplication_1/login.dart'; // Mantén tu importación de login.dart

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controladores para capturar los datos de cada campo
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDocController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variable para el Dropdown (Tipo de documento)
  String? tipoDocSeleccionado;

  // Variable para ocultar/mostrar contraseña
  bool ocultarPassword = true;

  // Lista de opciones para el tipo de documento
  final List<Map<String, String>> tiposDocumento = [
    {'value': 'CC', 'label': 'Cédula de ciudadanía'},
    {'value': 'TI', 'label': 'Tarjeta de identidad'},
    {'value': 'CE', 'label': 'Cédula de extranjería'},
  ];

  @override
  void dispose() {
    // Es una buena práctica limpiar los controladores al destruir el widget
    nombreController.dispose();
    apellidoController.dispose();
    numeroDocController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Unificando fondo
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25), // Padding unificado
          child: Column(
            children: [
              const SizedBox(height: 10),

              // LOGO / Brand Name (Estilo GOLDENBOOKING del Login)
              const Text(
                'GOLDENBOOKING',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B732A), // Versión más oscura del dorado
                  letterSpacing: -1,
                  fontFamily: 'Montserrat', // Asegúrate de tener la fuente configurada
                ),
              ),

              const SizedBox(height: 40),

              // TARJETA DE FORMULARIO (Estilo unificado)
              Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    // TITULOS DENTRO DE LA TARJETA
                    const Text(
                      "Crea tu cuenta",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Regístrate para acceder a tu reserva",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // FILA 1: NOMBRE Y APELLIDO
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nombreController,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: "Nombre",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: apellidoController,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: "Apellido",
                              prefixIcon: const Icon(Icons.badge_sharp), // Icono de identificación complementario a person
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // FILA 2: TIPO Y NÚMERO DE DOCUMENTO
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: tipoDocSeleccionado,
                            hint: const Text("Tipo Doc."),
                            style: const TextStyle(fontFamily: 'Montserrat', color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.assignment_ind_outlined), // Icono asignado al Tipo de documento
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            ),
                            items: tiposDocumento.map((tipo) {
                              return DropdownMenuItem<String>(
                                value: tipo['value'],
                                child: Text(
                                  tipo['value']!,
                                  style: const TextStyle(fontFamily: 'Montserrat'),
                                ), // Muestra 'CC', 'TI', etc. para ahorrar espacio horizontal
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                tipoDocSeleccionado = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Le da un poco más de espacio al número que al tipo
                          child: TextField(
                            controller: numeroDocController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: "Número documento",
                              prefixIcon: const Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // FILA 3: USERNAME Y EMAIL
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: usernameController,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: "Username",
                              prefixIcon: const Icon(Icons.alternate_email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined), // Icono asignado al Email
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // CONTRASEÑA
                    TextField(
                      controller: passwordController,
                      obscureText: ocultarPassword,
                      style: const TextStyle(fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            ocultarPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              ocultarPassword = !ocultarPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // BOTÓN REGISTRARSE (Estilo unificado)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aquí capturas e imprimes los datos recopilados
                          print("Nombre: ${nombreController.text}");
                          print("Apellido: ${apellidoController.text}");
                          print("Tipo Doc: $tipoDocSeleccionado");
                          print("Número Doc: ${numeroDocController.text}");
                          print("Username: ${usernameController.text}");
                          print("Email: ${emailController.text}");
                          print("Password: ${passwordController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37), // Dorado unificado
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "REGISTRARSE",
                          style: TextStyle(
                            fontSize: 16, // Pequeño ajuste para consistencia
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1, // Espaciado unificado
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // BOTÓN VOLVER AL LOGIN (Estilo unificado)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const Login(), // Asegúrate que tu Login se llama así
                          ),
                        ); // Regresa de forma limpia a la pantalla anterior (Login)
                      },
                      icon: const Icon(Icons.reply, color: Color(0xFFD4AF37)),
                      label: const Text(
                        "Volver al login",
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Footer unificado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '© 2026 GOLDENBOOKING. Todos los derechos reservados.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}