import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class NewPassPage extends StatefulWidget {
  const NewPassPage({super.key});

  @override
  State<NewPassPage> createState() => _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  String senha = '', confirmarSenha = '';

  TextEditingController senhaController = TextEditingController(),
      confirmarSenhaController = TextEditingController();

  void initState() {
    super.initState();
  }

  Future<void> validarSenhas() async {
    senha = senhaController.text.toString().trim();
    confirmarSenha = confirmarSenhaController.text.toString().trim();

    if (senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos por favor.'),
        ),
      );
    } else if (senha == confirmarSenha) {
      print(emailNovaSenha);
      JsonDBService.instance.alterarSenha(emailNovaSenha, senha);
      Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário atualizado com sucesso.')),
        );
        emailNovaSenha = '';
        print('email global vazio: $emailNovaSenha');
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('As senhas devem ser iguais.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corCinza,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 10,
            vertical: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/sobre',
                      );
                    },
                    icon: Icon(Icons.info),
                  ),
                ],
              ),
              SizedBox(height: 160),
              Image.asset(
                'assets/images/logomarca.png',
                width: MediaQuery.sizeOf(context).width * 0.2,
              ),
              SizedBox(height: 30),
              _textFieldComponent(
                true,
                'Nova Senha',
                true,
                senhaController,
              ),
              SizedBox(height: 30),
              _textFieldComponent(
                true,
                'Verificação de Senha',
                true,
                confirmarSenhaController,
              ),
              SizedBox(height: 30),
              _textBTN('Validar', validarSenhas),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldComponent(
    bool ativo,
    String titulo,
    bool obscuro,
    TextEditingController controller,
  ) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextField(
            obscureText: obscuro,
            enabled: ativo,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: corBranco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(),
                borderSide: BorderSide(color: corPreto, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textBTN(String titulo, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: corBranco,
        foregroundColor: corPreto,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.horizontal(),
          side: BorderSide(color: corPreto),
        ),
        fixedSize: Size(MediaQuery.sizeOf(context).width, 40),
      ),
      child: Text(
        titulo,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
