import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void initState() {
    super.initState();
    JsonDBService.instance.loadAll();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacementNamed('/login');
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corCinza,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.6,
              child: Image.asset('assets/images/logomarca.png'),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 38,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _animation.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      corAzulClaro,
                    ),
                    backgroundColor: Colors.transparent,
                    strokeWidth: 10,
                    year2023: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
