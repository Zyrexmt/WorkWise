import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class QuizzPage extends StatefulWidget {
  const QuizzPage({super.key});

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  int? _respostaSelecionada;
  Map<String, dynamic>? quizInfo;
  bool acertou = false;
  bool _acertou = false;
  bool _respondendo = false;
  bool _mostrarFeedback = false;
  int _perguntaAtual = 0;
  int _pontos = 0;
  int _totalPerguntas = 0;
  void initState() {
    super.initState();
    JsonDBService.instance.loadAll().then((_) {
      setState(() {
        quizInfo = JsonDBService.instance.findQuizByTitulo(
          tituloQuizzSalvo,
        );
        print(tituloQuizzSalvo);
      });
    });
  }

  Future<void> logout() async {
    userGlobal = null;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _mostarPopupTotal(String mensagem) {
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
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/home'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> responderPergunta(int respostaCorreta) async {
    if (_respondendo) return;
    if (_respostaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Você deve selecionar alguma alternativa para responder esta pergunta.',
          ),
        ),
      );
      return;
    }

    final acertou = respostaCorreta == _respostaSelecionada;

    setState(() {
      _respondendo = true;
      _mostrarFeedback = true;
      _acertou = acertou;
    });

    final duracao = acertou
        ? const Duration(seconds: 3)
        : const Duration(seconds: 5);

    Timer(duracao, () {
      if (!mounted) return;
      setState(() {
        if (acertou) _pontos++;
        _mostrarFeedback = false;
        _respondendo = false;
        _respostaSelecionada = null;
        avancarPergunta();
      });
    });
  }

  Widget _overlayFeedback() {
    return AnimatedOpacity(
      opacity: _mostrarFeedback ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: IgnorePointer(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: TweenAnimationBuilder(
            tween: Tween(
              begin: 0.0,
              end: _mostrarFeedback ? 1.0 : 0.0,
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, valor, child) {
              return Transform.scale(
                scale: valor,
                child: Icon(
                  _acertou ? Icons.check_circle : Icons.cancel,
                  color: _acertou ? Colors.green : Colors.red,
                  size: 120,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> avancarPergunta() async {
    _totalPerguntas = (quizInfo!['perguntas'] as List).length;

    double porcentagem = _pontos * 100 / _totalPerguntas;

    if (_perguntaAtual < _totalPerguntas - 1) {
      _perguntaAtual++;
    } else if (_perguntaAtual == _totalPerguntas - 1) {
      _mostarPopupTotal(
        'Percentual de acerto: ${porcentagem.toStringAsFixed(1)} %',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final perguntas = quizInfo?['perguntas'] as List<dynamic>?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corCinza,
        toolbarHeight: 100,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/home'),
            child: Image.asset(
              'assets/images/logotipo.png',
              width: MediaQuery.sizeOf(context).width * 0.2,
            ),
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userGlobal['nome'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              TextButton(
                onPressed: logout,
                style: TextButton.styleFrom(
                  fixedSize: Size(double.infinity, 5),
                ),
                child: Text(
                  '(Log out)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          SizedBox(width: 50),
          CircleAvatar(
            backgroundImage: userGlobal['foto'] != null
                ? AssetImage(userGlobal['foto'])
                : null,
            radius: 33,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Container(
        color: corCinza,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: 60,
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (perguntas != null && perguntas.isNotEmpty)
                Text(
                  perguntas[_perguntaAtual]['enunciado'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                )
              else
                const CircularProgressIndicator(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Questão ${_perguntaAtual + 1} de ${perguntas!.length}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    (perguntas[_perguntaAtual]['alternativas']
                            as List)
                        .length,
                itemBuilder: (context, index) {
                  final alternativa =
                      perguntas[_perguntaAtual]['alternativas'][index];
                  return _alternativa(index, alternativa);
                },
              ),
              _textBTN('Responder', () {
                responderPergunta(
                  perguntas[_perguntaAtual]['correta'],
                );
                print(_pontos);
              }),
              _textBTN('Pular', () {
                if (_respondendo) return;
                if (_perguntaAtual < perguntas.length - 1) {
                  setState(() {
                    _perguntaAtual++;
                    _respostaSelecionada = -1;
                  });
                } else if (_perguntaAtual == perguntas.length - 1) {
                  double porcentagem =
                      _pontos * 100 / _totalPerguntas;
                  setState(() {
                    if (porcentagem.isNaN) {
                      _mostarPopupTotal('Percentual de acerto: 0%');
                    } else {
                      _mostarPopupTotal(
                        'Percentual de acerto: ${porcentagem.toStringAsFixed(1)} %',
                      );
                    }
                  });
                }
              }),
              _overlayFeedback(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alternativa(int index, String resposta) {
    String letraAlternativa = '';

    switch (index) {
      case 0:
        letraAlternativa = 'a) ';
        break;
      case 1:
        letraAlternativa = 'b) ';
        break;
      case 2:
        letraAlternativa = 'c) ';
        break;
      default:
        print('Erro ao tentar ler alternativas');
    }

    final selecionada = _respostaSelecionada == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _respostaSelecionada = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '$letraAlternativa $resposta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: selecionada
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selecionada ? corazulMarinho : corPreto,
                ),
              ),
            ),
          ],
        ),
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
