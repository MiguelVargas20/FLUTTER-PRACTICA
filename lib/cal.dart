import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget{
  const Calculadora ({super.key});

@override
State<Calculadora> createState() => _CalculadoraState();
} 

class _CalculadoraState extends State<Calculadora>{
  String operacion ="";
  String resultado ="0";
  String numeroActual = "";
  List<String> elementos = [];



//
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Column(
        children: [
          //Expanded es para children, 
          Expanded(
            child: Container(
              //Es un atributo de un input, no se puede colocar un double infinity en el children, solo en el child
              width: double.infinity,

              //20 se refiere a puntos no a pixeles (medida usada en desarrollo móvil)
              padding: const EdgeInsets.all(40),
              child: Column(
                //Alinea al ancho
                mainAxisAlignment: MainAxisAlignment.end,

                //Alinea al alto 
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(operacion,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  ),

                  SizedBox(height: 10),
                  Text(
                    resultado,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
],
              ),
            ),
            ),
            Row(children: [boton("CA"), boton("CE"),  boton ("←"), boton("")]),
            Row(children: [boton("7") , boton("8"),  boton ("9"), boton("/")]),
            Row(children: [boton("4") , boton("5"),  boton ("6"), boton("*")]),
            Row(children: [boton("1") , boton("2"),  boton ("3"), boton("-")]),
            Row(children: [boton("0") , boton("."),  boton ("="), boton("+")]),

          ],
      ))

    );
  }

  void actionBoton(String valor){
    //print(valor);
    //Actualizarse
    setState(() {
      switch (valor) {
        case "CE":
          // Borra absolutamente todo
          operacion = "";
          break;

        case "CA":
          // Limpia la operación actual (puedes dejar el resultado anterior intacto)
          operacion = "";
          resultado = "0";
          break;

        case "←":
          // Elimina solo el último carácter si la cadena no está vacía
          if (operacion.isNotEmpty) {
            operacion = operacion.substring(0, operacion.length - 1);
          }
          break;

        case "+":
        case "-":
        case "*":
        case "/":
          if(numeroActual.isNotEmpty){
            elementos.add(numeroActual);
            elementos.add(valor);
            numeroActual = "";
            operacion += valor;
          }
          print(elementos);

          default:
              operacion += valor; 
              numeroActual += valor;
          break;
      }
});
}


  
  Widget boton (String texto){
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          actionBoton(texto);
        }, 
        child: Text(texto)));
  }
}