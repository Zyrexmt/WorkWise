import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  String email = '', pergunta = '', resposta = '';
  TextEditingController emailController = TextEditingController(),
      respostaController = TextEditingController();

  bool _perguntaCarreda = false;

  void initState() {
    super.initState();
  }

  Future<void> validarRespostaPergunta() async {
    resposta = respostaController.text.toString().trim();

    bool respostaCorreta = JsonDBService.instance.validarResposta(
      email,
      resposta,
    );
    if (respostaCorreta) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Redirecioando-o para a redefinição de senha.',
          ),
        ),
      );
      emailNovaSenha = email;
      Navigator.pushReplacementNamed(context, '/passReset');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resposta inválida.')));
    }
  }

  Future<void> carregarPergunta() async {
    email = emailController.text.toString().trim();
    pergunta = JsonDBService.instance.buscarPerguntaByEmail(email);
    setState(() {
      if (JsonDBService.instance.findUserByEmail(email) != null) {
        _perguntaCarreda = true;
      }
    });
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
                  SizedBox(height: 150,),
              Image.asset(
                'assets/images/logomarca.png',
                width: MediaQuery.sizeOf(context).width * 0.2,
              ),
              SizedBox(height: 30),
              _textInput(
                true,
                'Email',
                false,
                emailController,
                (value) => carregarPergunta(),
              ),
              SizedBox(height: 30),
              _textInput(
                _perguntaCarreda,
                _perguntaCarreda
                    ? pergunta
                    : 'Digite o e-mail para visualizar a pergunta',
                false,
                respostaController,
                (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Resposta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
              SizedBox(height: 30),
              _textBTN('Validar', validarRespostaPergunta),
              SizedBox(height: 30),
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

  Widget _textInput(
    bool ativo,
    String titulo,
    bool obscuro,
    TextEditingController controller,
    ValueChanged<String>? onChanged,
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
              fillColor: corBranco,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(),
                borderSide: BorderSide(color: corPreto, width: 2),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _textBTN(String titulo, VoidCallback? onPressed) {
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
