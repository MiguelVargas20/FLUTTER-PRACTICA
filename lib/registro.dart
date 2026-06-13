import 'package:flutter/material.dart';
import 'package:fluuter_aplication_1/login.dart';

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
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // LOGO (Estilo VetCare del Login)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 187, 175, 3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.pets, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 10),

              // TITULOS
              const Text(
                "Crea tu cuenta",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 223, 167, 15),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Regístrate para acceder a tu reserva",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // TARJETA DE FORMULARIO
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      
                      // FILA 1: NOMBRE Y APELLIDO
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nombreController,
                              decoration: InputDecoration(
                                labelText: "Nombre",
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [   
                          Expanded(
                            child: TextField(
                              controller: apellidoController,
                              decoration: InputDecoration(
                                labelText: "Apellido",
                                prefixIcon: const Icon(Icons.badge_sharp), // Icono de identificación complementario a person
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.assignment_ind_outlined), // Icono asignado al Tipo de documento
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              ),
                              items: tiposDocumento.map((tipo) {
                                return DropdownMenuItem<String>(
                                  value: tipo['value'],
                                  child: Text(tipo['value']!), // Muestra 'CC', 'TI', etc. para ahorrar espacio horizontal
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
                              decoration: InputDecoration(
                                labelText: "Número documento",
                                prefixIcon: const Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                              decoration: InputDecoration(
                                labelText: "Username",
                                prefixIcon: const Icon(Icons.alternate_email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: const Icon(Icons.email_outlined), // Icono asignado al Email
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // BOTÓN REGISTRARSE
                      SizedBox(
                        width: double.infinity,
                        height: 55,
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
                            backgroundColor: const Color.fromARGB(255, 218, 124, 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "REGISTRARSE",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // BOTÓN VOLVER AL LOGIN
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          ); // Regresa de forma limpia a la pantalla anterior (Login)
                        },
                        icon: const Icon(Icons.reply, color: Color.fromARGB(255, 226, 18, 3)),
                        label: const Text(
                          "Volver al login",
                          style: TextStyle(
                            color: Color.fromARGB(255, 230, 150, 3),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}