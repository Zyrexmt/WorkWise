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
  int _perguntaAtual = 0;

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
                onPressed: () {},
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
          Icon(Icons.account_circle_outlined, size: 70),
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
              _textBTN('Responder', () {}),
              _textBTN('Pular', () {
                if (_perguntaAtual < perguntas.length - 1) {
                  setState(() {
                    _perguntaAtual++;
                    _respostaSelecionada = -1;
                  });
                }
              }),
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
