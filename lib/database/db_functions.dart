import 'package:catolica_mhc/pages_default/certificados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../functions/app_logic.dart';
import '../pages_default/notificacoes.dart';
import 'db_firestore.dart';

List<Map<String, String>> listaComDadosDosEstudantes = <Map<String, String>>[];
List<Map<String, String>> listaEstudanteAtual = <Map<String, String>>[];

// Trecho de seed inicial comentado após popular o Firestore.
// Caso precise popular um banco vazio no primeiro login, basta descomentar este bloco
// e a chamada dentro de getMatriculaUsuario.
/*
Future<void>? _pendingUserLoad;
String? _pendingUserEmail;

Future<void> _seedInitialCertificatesIfNeeded(
    FirebaseFirestore db, int matricula) async {
  final existingCerts = await db
      .collection("certificados_mhc")
      .where('cert_numero_de_matricula_usu', isEqualTo: matricula)
      .limit(1)
      .get();

  if (existingCerts.docs.isNotEmpty) return;

  final sampleCerts = <Map<String, dynamic>>[
    {
      'cert_id': 1,
      'cert_titulo': 'Estágio em Desenvolvimento Mobile',
      'cert_instituicao': 'Católica SC',
      'cert_carga_horaria': 80.0,
      'cert_tipo_certificado': 'Estágio',
      'cert_status': 'Aprovado',
      'cert_situacao_do_certificado': 'Certificado validado',
      'cert_coord_obs': 'Horas de estágio contabilizadas com sucesso.',
      'cert_img': '',
      'cert_numero_de_matricula_usu': matricula,
    },
    {
      'cert_id': 2,
      'cert_titulo': 'Semana Acadêmica de Engenharia de Software',
      'cert_instituicao': 'Católica SC',
      'cert_carga_horaria': 30.0,
      'cert_tipo_certificado': 'Palestra',
      'cert_status': 'Aprovado',
      'cert_situacao_do_certificado': 'Certificado validado',
      'cert_coord_obs': 'Participação confirmada pela coordenação.',
      'cert_img': '',
      'cert_numero_de_matricula_usu': matricula,
    },
    {
      'cert_id': 3,
      'cert_titulo': 'Hackathon Inovação & Cloud',
      'cert_instituicao': 'Católica SC',
      'cert_carga_horaria': 25.0,
      'cert_tipo_certificado': 'Outros',
      'cert_status': 'Enviado',
      'cert_situacao_do_certificado': 'Aguardando confirmação',
      'cert_coord_obs': 'Em análise pela coordenação do curso.',
      'cert_img': '',
      'cert_numero_de_matricula_usu': matricula,
    },
    {
      'cert_id': 4,
      'cert_titulo': 'Workshop Flutter & Firebase na Prática',
      'cert_instituicao': 'GDG Joinville',
      'cert_carga_horaria': 15.0,
      'cert_tipo_certificado': 'Palestra',
      'cert_status': 'Aprovado',
      'cert_situacao_do_certificado': 'Pendente',
      'cert_coord_obs': '',
      'cert_img': '',
      'cert_numero_de_matricula_usu': matricula,
    },
  ];

  for (final cert in sampleCerts) {
    await db.collection("certificados_mhc").add(cert);
  }
}

Future<void> _ensureUserAndSeedData(FirebaseFirestore db, String email) async {
  final existingUser = await db
      .collection("usuarios_mhc")
      .where('usu_email', isEqualTo: email)
      .limit(1)
      .get();

  if (existingUser.docs.isNotEmpty) {
    final data = existingUser.docs.first.data();
    final matricula = (data['usu_num_matricula'] as num?)?.toInt() ?? 6274821;
    await _seedInitialCertificatesIfNeeded(db, matricula);
    return;
  }

  // Aproveita dados da coleção `aluno` se já existir para o e-mail logado
  final alunoQuery = await db
      .collection("aluno")
      .where('emailAluno', isEqualTo: email)
      .limit(1)
      .get();

  String nome = 'Davi';
  String sobrenome = 'Ferreira';
  String curso = 'Engenharia de Software';
  int matricula = 6274821;
  String senha = '';

  if (alunoQuery.docs.isNotEmpty) {
    final aluno = alunoQuery.docs.first.data();
    nome = aluno['primeiroNome']?.toString() ?? nome;
    sobrenome = aluno['ultimoNome']?.toString() ?? sobrenome;
    curso = aluno['nomeCurso']?.toString() ?? curso;
    matricula = (aluno['codMatricula'] as num?)?.toInt() ?? matricula;
    senha = aluno['senhaAluno']?.toString() ?? '';
  }

  await db.collection("usuarios_mhc").add({
    'usu_curso': curso,
    'usu_email': email,
    'usu_img_perfil': '',
    'usu_nome': nome,
    'usu_num_matricula': matricula,
    'usu_senha': senha,
    'usu_sobrenome': sobrenome,
    'usu_telefone': '(47) 99999-9999',
  });

  await _seedInitialCertificatesIfNeeded(db, matricula);
}
*/

Future getMatriculaUsuario(
    String? email,
    List<String> usuCurso,
    List<String> usuEmail,
    List<String> usuImgPerfil,
    List<String> usuNome,
    List<String> usuSenha,
    List<int> usuNumMatricula,
    List<String> usuSobrenome,
    List<String> usuTelefone) async {
  if (email == null || email.isEmpty) return;

  FirebaseFirestore db = DBFirestore.get();

  /*
  if (_pendingUserLoad == null || _pendingUserEmail != email) {
    _pendingUserEmail = email;
    _pendingUserLoad = _ensureUserAndSeedData(db, email).whenComplete(() {
      _pendingUserLoad = null;
    });
  }
  await _pendingUserLoad;
  */

  final QuerySnapshot result = await db
      .collection("usuarios_mhc")
      .where('usu_email', isEqualTo: email)
      .get();
  final List<DocumentSnapshot> documents = result.docs;

  usuCurso.clear();
  usuEmail.clear();
  usuImgPerfil.clear();
  usuNome.clear();
  usuSenha.clear();
  usuNumMatricula.clear();
  usuSobrenome.clear();
  usuTelefone.clear();

  for (final element in documents) {
    usuCurso.add(element.get('usu_curso')?.toString() ?? '');
    usuEmail.add(element.get('usu_email')?.toString() ?? '');
    usuImgPerfil.add(element.get('usu_img_perfil')?.toString() ?? '');
    usuNome.add(element.get('usu_nome')?.toString() ?? '');
    usuSenha.add(element.get('usu_senha')?.toString() ?? '');
    usuNumMatricula
        .add((element.get('usu_num_matricula') as num?)?.toInt() ?? 0);
    usuSobrenome.add(element.get('usu_sobrenome')?.toString() ?? '');
    usuTelefone.add(element.get('usu_telefone')?.toString() ?? '');
  }
}

Future alterarSituacaoCertificado(List<int> idListNotificacoes) async {
  await getMatriculaUsuario(
      email,
      usuCurso,
      usuEmail,
      usuImgPerfil,
      usuNome,
      usuSenha,
      usuNumMatricula,
      usuSobrenome,
      usuTelefone);
  FirebaseFirestore db = DBFirestore.get();
  final QuerySnapshot result = await db
      .collection('certificados_mhc')
      .where('cert_id',
          isEqualTo:
              idListNotificacoes[indexDoCertificadoSelecionadoNotificacoes])
      .get();
  final List<DocumentSnapshot> documents = result.docs;

  int idCertificadoNotificacoes =
      idListNotificacoes[indexDoCertificadoSelecionadoNotificacoes];

  for (final element in documents) {
    if (element.get('cert_id') == idCertificadoNotificacoes) {
      String nameDoc = element.id;
      await db
          .collection('certificados_mhc')
          .doc(nameDoc)
          .update({'cert_situacao_do_certificado': 'Pendente'}).then(
        (value) => debugPrint("Documento Atualizado para Pendente"),
        onError: (e) => debugPrint("Erro atualizando o documento: $e"),
      );
    }
  }
}

Future<void> editarPerfil(String novoNumeroTel) async {
  FirebaseFirestore db = DBFirestore.get();
  await getMatriculaUsuario(
      email,
      usuCurso,
      usuEmail,
      usuImgPerfil,
      usuNome,
      usuSenha,
      usuNumMatricula,
      usuSobrenome,
      usuTelefone);

  final QuerySnapshot result = await db
      .collection('usuarios_mhc')
      .where('usu_email', isEqualTo: email)
      .get();
  final List<DocumentSnapshot> documents = result.docs;

  for (final element in documents) {
    if (usuEmail.isNotEmpty && element.get('usu_email') == usuEmail[0]) {
      final String nomeDoc = element.id;
      await db.collection('usuarios_mhc').doc(nomeDoc).update({
        'usu_telefone': novoNumeroTel,
      }).then(
        (value) => debugPrint("Documento Atualizado"),
        onError: (e) => debugPrint("Erro atualizando o documento: $e"),
      );
    }
  }
}

Future<void> deletarCertificado(List<int> idListCertificado) async {
  FirebaseFirestore db = DBFirestore.get();
  final QuerySnapshot result = await db.collection("certificados_mhc").get();
  final List<DocumentSnapshot> documents = result.docs;

  int idCertificado =
      idListCertificado[indexDoCertificadoSelecionadoCertificados];

  for (final element in documents) {
    if (element.get('cert_id') == idCertificado) {
      final String nomeDoc = element.id;
      await db.collection('certificados_mhc').doc(nomeDoc).delete().then(
            (value) => debugPrint("Documento deletado"),
            onError: (e) => debugPrint("Erro deletando o documento: $e"),
          );
    }
  }
}

Future<void> addCertificado(
    double certCargaHoraria,
    String certImg,
    String certInstituicao,
    String certTipoCertificado,
    String certTitulo) async {
  FirebaseFirestore db = DBFirestore.get();
  await getMatriculaUsuario(
      email,
      usuCurso,
      usuEmail,
      usuImgPerfil,
      usuNome,
      usuSenha,
      usuNumMatricula,
      usuSobrenome,
      usuTelefone);
  // Referencia ao documento remoto
  final QuerySnapshot result = await db.collection("certificados_mhc").get();
  final List<DocumentSnapshot> documents = result.docs;
  int maxId = 0;

  for (final element in documents) {
    final currentId = (element.get('cert_id') as num?)?.toInt() ?? 0;
    if (currentId > maxId) {
      maxId = currentId;
    }
  }
  final int idDoCertificadoNovo = maxId + 1;

  var docRef = db.collection("certificados_mhc");

  await docRef
      .doc()
      .set({
        'cert_carga_horaria': certCargaHoraria,
        'cert_coord_obs': '',
        'cert_id': idDoCertificadoNovo,
        'cert_img': certImg,
        'cert_instituicao': certInstituicao,
        'cert_numero_de_matricula_usu':
            usuNumMatricula.isNotEmpty ? usuNumMatricula[0] : 0,
        'cert_situacao_do_certificado': 'Enviado',
        'cert_status': 'Enviado',
        'cert_tipo_certificado': certTipoCertificado,
        'cert_titulo': certTitulo
      })
      .then((value) => debugPrint("Deu certo!"))
      .catchError((error) => debugPrint('Deu errado :( $error'));
}
