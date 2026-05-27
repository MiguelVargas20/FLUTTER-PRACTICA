import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tarjeta Miguel Vargas"),
        ),
        body: Center(
          child: Container(
            width: 390,
            
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(  
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Miguel Vargas",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "mvargas150@gmail.com",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: const [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "31115692534",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                     const SizedBox(height: 20),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Bogotá",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}