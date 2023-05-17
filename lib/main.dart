import 'package:clean_architecture_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';

void main() async {
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NumberTrivia',
      home: NumberTriviaPage(),
    );
  }
}
