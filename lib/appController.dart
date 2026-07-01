import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/pages/forgotPassPage.dart';
import 'package:modulo_c1_v1/pages/homePage.dart';
import 'package:modulo_c1_v1/pages/loginPage.dart';
import 'package:modulo_c1_v1/pages/splashPage.dart';

class AppController extends StatelessWidget {
  const AppController({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/forgot': (context) => const ForgotPassPage()
        
      }, initialRoute: '/splash',
    );
  }
}