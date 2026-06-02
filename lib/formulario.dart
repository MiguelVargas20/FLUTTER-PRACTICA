import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class RegistroUsuario extends StatelessWidget {
  const RegistroUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('es','ES'),
      supportedLocales: [Locale('es', 'ES'),
      ],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

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

//Variable acepta Terminos
bool aceptaTerminos = false;

//Variable swith notificacion
bool notificaciones = false;

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

                  //Validaciones del campo Nombre Usuario
                  validator: (value) {

                    //Valida cuando el nombre va vacio
                    if (value == null || value.isEmpty) {
                      return "Porfavor, ingresa tu nombre";
                    }

                    //Aca se indica que si esta el nombre no haga nada 
                    return null;
                  },
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
                  
                  validator: (value){

                    //Validar que el arroba este en en Correo electrnico
                    if (value == null || value.isEmpty || !value.contains("@")){
                      return "Porfavor, ingresa tu correo electrónico";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                      return "Porfavor, ingresa un correo electrónico válido";}
                    return null;
                    
                  },
                ),

                const SizedBox(height: 20),
                
                //Phone
                TextFormField(
                  controller: phoneController,

                  //Validacion numeros en telefono
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],


                  decoration: const InputDecoration(
                    labelText: "Numero Telefonico",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),

                  ),

                  //Validacion telefono
                  validator: (value) {

                    if (value == null || value.isEmpty){
                      return "Porfavor, ingresa tu telefono";
                    }
                    if(value.length < 10){
                      return "Porfavor ingresa un telefono válido";
                    }
                    return null;
                    },

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

                  //Validacion contraseña
                  validator: (value) {

                    if (value == null || value.isEmpty){
                      return "Porfavor, ingresa tu contraseña";
                    }
                    if(value.length < 8){
                      return "Porfavor ingresa una contraseña mayor a 8 carácteres";
                    }
                    return null;
                    },

                ),

                //Lista roles
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: rol,

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
                              fechaNacimiento = fecha;
                              });
                          }
                      },
                  )

                ),

                const SizedBox(height: 20),

                //Checkbox condiciones y terminos
                CheckboxListTile(
                  title: const Text("Acepto los terminos y condiciones"),
                  value: aceptaTerminos,
                  onChanged: (value){
                    setState(() {
                      //Actualizar el estado del checkbox
                      aceptaTerminos = value!;
                    });
                  }),

                  SizedBox(height: 20,),

                  //Switch para recibir notificaciones
                  SwitchListTile(
                    title: const Text("Recibir notificaciones"),
                    value: notificaciones,
                    onChanged: (value){
                      setState(() {
                        notificaciones = value;
                      });
                    }),
                  
                  const SizedBox(height: 20,),

                  //CheckboxListTittle
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:(){
                      //Logica para validar el formulario y registrar usuario(opcional)

                      //Valida los campos del formulario y el aceptar Terminos que este seleccionado para imprimir que esta procesando el registro
                      if (_formkey.currentState!.validate() && aceptaTerminos) {
                        print("Formulario válido, Procesar registro");

                      //La variable acepta terminos por default es false entonces cuando no esta completa manda el else que requiere los campos/acceptTerms
                      } else {
                        print("Porfavor, complete el formulario y acepte los terminos",);
                      }
                    },
                    child: const Text("Registrar"),
                  ),
                )
              ],
          ), 
        ),
      ),
    );
  }
}