import 'package:flutter/material.dart';
import 'package:poke_app_arc/entry_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke App Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 94, 10, 10),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 94, 10, 10),
        ),
      ),
      home: EntryPage(),
    );
  }
}
