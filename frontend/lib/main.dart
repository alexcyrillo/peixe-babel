import 'package:flutter/material.dart';
import 'package:peixe_babel/pages/main_page.dart';

Future<void> main() async {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Peixe Babel', home: const IndexPage());
  }
}
