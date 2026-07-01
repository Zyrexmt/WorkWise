import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class JsonDBService {
  static final JsonDBService instance = JsonDBService._init();
  JsonDBService._init();

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> quizzes = [];

  bool _loaded = false;

  Future<void> loadAll() async {
    if (_loaded) return;
    users = await _loadReadOnly('users.json');
    quizzes = await _loadReadOnly('quizzes.json');
    _loaded = true;
    print('Carregado');
    ;
  }

  Future<List<Map<String, dynamic>>> _loadReadOnly(
    String fileName,
  ) async {
    final raw = await rootBundle.loadString('assets/data/$fileName');
    print('readOnly - fase 1');
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  Future<File> _localFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  Future<void> _saveUsers() async {
    final file = await _localFile('users.json');
    await file.writeAsString(jsonEncode(users));
  }

  Map<String, dynamic>? findUserByEmail(String email) {
    try {
      print('Email encontrado - fase 2');
      return users.firstWhere((u) => u['email'] == email);
    } catch (_) {
      print('Email nao encontrado');
      return null;
    }
  }

  String validarLogin(String email, String senha) {
    final user = findUserByEmail(email);
    if (user == null) return 'email_invalido';
    if (user['senha'] != senha) return 'senha_invalida';
    return 'ok';
  }

  bool validarResposta(String email, String resposta) {
    final user = findUserByEmail(email);
    if (user == null) return false;
    return user['resposta'].toString().toLowerCase() ==
        resposta.toLowerCase();
  }

  Future<void> alterarSenha(String email, String novaSenha) async {
    final index = users.indexWhere((u) => u['email'] == email);
    if (index != -1) {
      users[index]['senha'] = novaSenha;
      await _saveUsers();
    }
  }

  Map<String, dynamic>? findQuizByTitulo(String titulo) {
    try {
      return quizzes.firstWhere((q) => q['titulo'] == titulo);
    } catch (_) {
      return null;
    }
  }
}
