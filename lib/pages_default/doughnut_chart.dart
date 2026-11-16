// Arquivo para entrada de dados do gráfico que se encontra
// na dashBoard inicial após feito o login
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

// -- Obtenção de dados

// teste Pegar matricula
List<int> matriculaList = <int>[];

// Map<int, List<String>> params = {
//     'matriculaUsuario': null,
//     'certificados': [],
// } as Map<int, List<String>>;

var listaMatriculaComCertificadosVinculados = {
  'matriculaUsuario': 0,
  'certificados': {
    'instituicao': '',
    'img': '',
    'carga_horaria': 0,
    'tipo_certificado': '',
    'status': '',
    /*
      https://www.tutorialspoint.com/dart_programming/dart_programming_map.htm
      fiz com base nesse site aqui
       */
  }
};

Future getUsuarioRelationFirebase(List<int> matriculaList) async {
  final QuerySnapshot result = await Future.value(
      FirebaseFirestore.instance.collection("usuarios_mhc").get()); //.limit(1).
  final List<DocumentSnapshot> documents = result.docs;

  late int matriculaUsuario;
  int matriculas;

  // Pra cada documento dentro da collection usuarios_mhc
  for (var element in documents) {
    // Pega a matricula do usuário
    matriculaUsuario = element.get("usu_num_matricula");

    // pra cada matricula em matriculaList (matriculas que estão na parte do certificado)
    for (matriculas in matriculaList) {
      /*
        * checa se a matricula do usuário que pegou anteriormente,
        * é igual a matricula que está na collection de certificados
        * */
      if (matriculaUsuario == matriculas) {
        listaMatriculaComCertificadosVinculados['matriculaUsuario'] =
            matriculaUsuario;
        listaMatriculaComCertificadosVinculados['certificados'] = {
          'instituicao': instituicaoList[matriculas],
          'img': imgList[matriculas],
          'carga_horaria': cargaHorariaList[matriculas],
          'tipo_certificado': tipoCertificacaoList[matriculas],
          'status': statusList[matriculas],
        };
      }
    }
  }
}
// fim teste

List<String> instituicaoList = <String>[];
List<String> imgList = <String>[];
List<double> cargaHorariaList = <double>[];
List<String> tipoCertificacaoList = <String>[];
List<String> statusList = <String>[];

Future getCertificadosFirebase(
    List<int> matriculaList,
    List<String> instituicaoList,
    List<String> imgList,
    List<double> cargaHorarialist,
    List<String> tipoCertificacaolist,
    List<String> statusList) async {
  final QuerySnapshot result = await Future.value(FirebaseFirestore.instance
      .collection("certificados_mhc")
      .get()); //.limit(1).

  final List<DocumentSnapshot> documents = result.docs;

  // Parte do teste pegar matricula
  late int matricula;
  //

  late String instituicao;
  late String img;
  late double cargaHoraria;
  late String tipoCertificacao;
  late String status;

  for (var element in documents) {
    matricula = int.parse(element.get("usu_numero_de_matricula").toString());
    matriculaList.add(matricula);

    instituicao = element.get("usu_instituicao").toString();
    instituicaoList.add(instituicao);

    img = element.get("uso_imagem").toString();
    imgList.add(img);

    cargaHoraria = double.parse(element.get("usu_carga_horaria").toString());
    cargaHorarialist.add(cargaHoraria);

    status = element.get("usu_status").toString();
    statusList.add(status);

    tipoCertificacao = element.get("usu_tipo_certificado").toString();
    tipoCertificacaolist.add(tipoCertificacao);
  }
}

// -- Fim obtenção de dados

// final List<ChartData> chartData = [
//   ChartData('Estágios', 300, Color.fromRGBO(9,0,136,1)),
//   ChartData('Palestras', 15, Color.fromRGBO(147,0,119,1)),
//   ChartData('Cursos', 20, Color.fromRGBO(228,0,124,1)),
//   ChartData('Outros', 5, Color.fromRGBO(255,189,57,1)),
// ];

class ChartData {
  final String x; // Nome
  final double y; // Porcentagem
  final Color color;

  ChartData(this.x, this.y, this.color);
}
