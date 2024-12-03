import 'package:api_client/repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
            child: ElevatedButton(
                onPressed: () async {
                  final coffees = await ApiRepository.getCoffees();
                  print(coffees[0].title);
                },
                child: const Text("call APi"))),
      ),
    );
  }
}
