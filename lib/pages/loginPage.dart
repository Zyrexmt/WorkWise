import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', senha = '';

  TextEditingController emailController = TextEditingController(),
      senhaController = TextEditingController();

  int _erroAmbosCount = 0;
  int _segundosRestantes = 0;
  bool get _bloqueadoTemporariamente => _segundosRestantes > 0;
  Timer? _timerBloqueio;

  final Map<String, int> _erroSenhaPorEmail = {};
  final Set<String> _emailBloqueados = {};

  @override
  void dispose() {
    _timerBloqueio?.cancel();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _iniciarBloqueio() {
    setState(() => _segundosRestantes = 15);
    _timerBloqueio?.cancel();
    _timerBloqueio = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      setState(() {
        _segundosRestantes--;
        if (_segundosRestantes <= 0) {
          timer.cancel();
          _erroAmbosCount = 0;
        }
      });
    });
  }

  Future<void> login() async {
    if (_bloqueadoTemporariamente) return;

    email = emailController.text.toString().trim();
    senha = senhaController.text.toString().trim();

    if (_emailBloqueados.contains(email)) {
      _mostarPopupErro(
        'Usuário bloqueado. Tente outro usuário ou reinicie o aplicativo.',
      );
      return;
    }

    final resultado = JsonDBService.instance.validarLogin(
      email,
      senha,
      // 'ari_malvadao@exemplo.com',
      // 'ariari',
    );

    switch (resultado) {
      case 'ok':
        _erroAmbosCount = 0;
        _erroSenhaPorEmail.remove(email);
        Navigator.pushReplacementNamed(context, '/home');
        break;

      case 'email_invalido':
        _erroAmbosCount++;
        _mostarPopupErro('E-mail e senha incorretos.');
        if (_erroAmbosCount >= 3) _iniciarBloqueio();
        break;
      case 'senha_invalida':
        _erroSenhaPorEmail[email] =
            (_erroSenhaPorEmail[email] ?? 0) + 1;
        _mostarPopupErro('Senha incorreta');
        if (_erroSenhaPorEmail[email]! >= 5) {
          _emailBloqueados.add(email);
        }
        break;
    }
  }

  void _mostarPopupErro(String mensagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/images/logomarca.png',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controlesAtivos = !_bloqueadoTemporariamente;

    return Scaffold(
      backgroundColor: corCinza,
      appBar: AppBar(
        backgroundColor: corCinza,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/sobre'),
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logomarca.png',
                    width: MediaQuery.sizeOf(context).width * 0.2,
                  ),
                  SizedBox(height: 50),
                  _TextInput(true, 'Email', emailController, false),
                  SizedBox(height: 30),
                  _TextInput(true, 'Senha', senhaController, true),
                  SizedBox(height: 30),

                  if (_bloqueadoTemporariamente)
                    Text(
                      'Tente novamente em $_segundosRestantes s',
                      style: TextStyle(color: Colors.red),
                    ),

                  _textBTN('Entrar', controlesAtivos ? login : null),
                  SizedBox(height: 30),

                  TextButton(
                    onPressed: controlesAtivos
                        ? () => Navigator.pushNamed(
                            context,
                            '/forgot',
                          )
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: corAzulClaro,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadiusGeometry.horizontal(),
                        side: BorderSide.none,
                      ),
                    ),
                    child: Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: corAzulClaro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _TextInput(
    bool ativo,
    String titulo,
    TextEditingController controller,
    bool obscuro,
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
