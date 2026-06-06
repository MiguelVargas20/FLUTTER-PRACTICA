import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String operacion = "";
  String resultado = "0";
  String numeroActual = "";
  List<String> elementos = [];
  List<String> calculo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      operacion,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(height: 10),
                    Text(
                      resultado,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(children: [boton('CA'), boton('CE'), boton('←'), boton('')]),
            Row(children: [boton('7'), boton('8'), boton('9'), boton('/')]),
            Row(children: [boton('4'), boton('5'), boton('6'), boton('*')]),
            Row(children: [boton('1'), boton('2'), boton('3'), boton('-')]),
            Row(children: [boton('0'), boton('.'), boton('='), boton('+')]),
          ],
        ),
      ),
    );
  } //build

  void actionBoton(String valor) {
    //Primero print(valor);
    //Luego
    setState(() {
      switch (valor) {
        case 'CA':
          operacion = "";
          resultado = "0";
          numeroActual = "";
          elementos.clear();
          return;

        case 'CE':
          operacion = "";
          return;
        case '←':
          if (operacion.isNotEmpty) {
            operacion = operacion.substring(0, operacion.length - 1);
          }
          return;

        case "+":
        case "-":
        case "*":
        case "/":
          if (numeroActual.isNotEmpty) {
            elementos.add(numeroActual);
            elementos.add(valor);
            numeroActual = "";
            operacion += valor;
          }
          print(elementos);

          break;

        case "=":
        //Si no hay un numero, agregue numero actual a elementos
          if (numeroActual.isNotEmpty) {
            elementos.add(numeroActual);
          }

          //Duplico elementos para poder modificarlo
          calculo = List.from(elementos);

          bool hayOperadores = true;

          //While evalua los operadores multiplicacion y division
          while (hayOperadores) {
            hayOperadores = false;
            
            //Empieza desde 0 y va incrementeando
            for (int i = 0; i < calculo.length; i++) {

              //Evalua de izquierda a derecha si encuentra * o /
              if (calculo[i] == "*" || calculo[i] == "/") {


                //Hace que con "i" se remplace una posision anterior y una posision despues
                double a = double.parse(calculo[i - 1]);
                double b = double.parse(calculo[i + 1]);

                double r = 0;

                //Evalua el if si es multipliacion 
                if (calculo[i] == "*") {
                  r = a * b;

                //Sino evalua que es division y ejecuta
                } else {
                  r = a / b;
                }


                //Remplaza en el string con el resultado de la multiplicacion o division en el rango de (i-1,i,i+1)
                calculo.replaceRange(i - 1, i + 2, [r.toString()]);

                hayOperadores = true;

                break;
              }
            }
          }

          double total = double.parse(calculo[0]);

          //Arranca con el arreglo ya FINAL para hacer la operacion de manera limpia
          for (int i = 1; i < calculo.length; i += 2) {
            String operador = calculo[i];

            double numero = double.parse(calculo[i + 1]);

            switch (operador) {
              case "+":
                total += numero;
                break;

              case "-":
                total -= numero;
                break;
            }
          }

          resultado = total.toString();

          elementos.clear();

          numeroActual = resultado;

          break;

        default:
          operacion += valor;
          numeroActual += valor;
          break;
      }
    });
  }

  Widget boton(String texto) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          actionBoton(texto);
        },
        child: Text(texto),
      ),
    );
  }
}