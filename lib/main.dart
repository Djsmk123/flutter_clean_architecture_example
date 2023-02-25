import 'package:flutter/material.dart';
import 'package:mvvm_movies_app/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
