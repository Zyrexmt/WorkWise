import 'package:flutter/material.dart';
import 'package:modulo_c1_v1/global/variaveis.dart';
import 'package:modulo_c1_v1/service/jsonService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> quiz = [];

  void initState() {
    super.initState();

    JsonDBService.instance.loadAll().then((_) {
      setState(() {
        quiz = JsonDBService.instance.quizzes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corCinza,
      appBar: AppBar(
        backgroundColor: corCinza,
        toolbarHeight: 100,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/images/logotipo.png',
            width: MediaQuery.sizeOf(context).width * 0.2,
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
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Quizes',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: quiz.length,
                  itemBuilder: (context, index) {
                    return _cardQuiz(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardQuiz(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/quizz');
        tituloQuizzSalvo = quiz[index]['titulo'];
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: corBranco,
          border: Border.all(color: corPreto, width: 2),
          borderRadius: BorderRadius.horizontal(),
        ),
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(quiz[index]['titulo'])],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text(quiz[index]['data'])],
            ),
          ],
        ),
      ),
    );
  }
}
