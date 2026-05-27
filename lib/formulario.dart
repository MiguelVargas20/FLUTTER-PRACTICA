import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_locations.dart';


class RegistroUsuario extends StatelessWidget {
  const RegistroUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('es','ES'),
      supportedLocales: [Locale('es', 'ES'),
      ],

      localizationsDelegates: const[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetLocalizations.delegate,
        GlobalCupertLocalizations.delegate,

      ],
      home: RegistroUsuario(),
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formkey = GlobalKey<FormState>();

//Controladores inputs
final nombreControler = TextEditingController();
final emailController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();

//Variables del sistema
//Varaible para Rol default
String rol = "Usuario";

//Variable de fecha vacia - Tambien se puede establecer con un valor
DateTime? fechaNacimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formkey,

          child: Column(
            children: [
              const Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                "Registro usuario",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30,),

                TextFormField(
                  controller: nombreControler,

                  decoration: InputDecoration(
                    labelText: "Nombre Usuario",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)

                  ),
                ),

                const SizedBox(height: 20),
                
                //Email
                TextFormField(
                  controller: emailController,

                  //Valida que este el arroba en el campo
                  keyboardType: TextInputType.emailAddress,

                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  
                ),

                const SizedBox(height: 20),
                
                //Phone
                TextFormField(
                  controller: phoneController,

                  //Validacion numeros en telefono
                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    labelText: "Numero Telefonico",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),

                  ),
                ),

                const SizedBox(height: 20),

                //Password
                TextFormField(
                  controller: passwordController,

                  //Input que muestra la contraseña en puntos
                  obscureText: true,

                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                //Lista roles
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: rol,

                  decoration: const InputDecoration(
                    labelText: "Rol",
                    border: OutlineInputBorder(),
                  ),

                  items: const[

                    //value: Valor asignado a la variable a DB
                    //Child: Texto mostrado en el form
                    DropdownMenuItem(value: "Usuario", child: Text("Usuario"),),
                    DropdownMenuItem(value: "Administrador", child: Text("Administrador"),),
                    DropdownMenuItem(value: "Cliente", child: Text("Cliente"),),
                  ],
                  onChanged: (value){
                    setState(() {
                      rol = value!;
                    });
                  },
                ),

              //SizedBox es un cajon vacio 
                const SizedBox(height: 20),

                SizedBox(
                  //double.infinity es como el width  (auto)
                  width: double.infinity,

                  //Creamos hijo calendario
                  child: ElevatedButton.icon(

                    //Icono calendario
                    icon: const Icon(Icons.calendar_month),

                    //Label calendario texto
                    label:Text(

                      //If donde se indica si esta vacia que aparezca seleccionar fecha nacimiento y sino es asi establecer parametros day/month/year
                      fechaNacimiento == null
                      ? 'Seleccionar Fecha Nacimiento'
                      : 'Fecha: ${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}',
                      ),

                    //Hacemos que el calendario como dato inicial tenga la fecha actual
                      onPressed: () async{
                        DateTime? fecha = await showDatePicker(
                          context: context,
                          
                          //Inicio en ahora
                          initialDate: DateTime.now(),

                          //Fecha inicial a la que se puede devolver
                          firstDate: DateTime(1950), 
                          lastDate: DateTime(2027),
                          );
                      //Si fecha es 
                          if (fecha != null){
                            setState(() {
                              
                            });

                          }
                      },
                  )

                )


            ],
          ), 
        ),
      ),
    );
  }
}