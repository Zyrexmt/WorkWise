import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corCinza,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logomarca.png',
                width: 150,
                height: 150,
              ),

              SizedBox(height: 50),

              Text(
                'O PsicoQuiz é um aplicativo voltado para o estudo interativo e divertido de temas como saúde emocional, inteligência e conhecimentos específicos como segurança no trabalho.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 50),

              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                style: TextButton.styleFrom(
                  foregroundColor: corAzulClaro,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.horizontal(),
                    side: BorderSide(color: corAzulClaro, width: 2),
                  ),
                  fixedSize: Size(130, 40),
                ),
                child: Text(
                  'Voltar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
