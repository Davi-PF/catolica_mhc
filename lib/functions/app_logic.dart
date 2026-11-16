import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/db_functions.dart';
import '../services/auth_service.dart';

/*void ShowModal(BuildContext context) {
  //code to execute on button press
  //botao aparece as coisas
  showModalBottomSheet<void>(
    context: context,
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Center(
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: StadiumBorder(),
                        minimumSize: Size(300, 43),
                        maximumSize: Size(300, 43),
                        backgroundColor: Colors.red[900]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.add_chart_sharp),
                        Text("Inserir certificado     ",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnviarCertificados(matricula: widget.matricula)));
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: StadiumBorder(),
                      minimumSize: Size(300, 43),
                      maximumSize: Size(300, 43),
                      backgroundColor: Colors.red[900]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.camera_enhance),
                      Text(
                        "Escanear certificado",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}*/ // void show modal

String? get email => AuthService.to.user?.email;
List<String> usuCurso = <String>[];
List<String> usuEmail = <String>[];
List<String> usuImgPerfil = <String>[];
List<String> usuNome = <String>[];
List<String> usuSenha = <String>[];
List<int> usuNumMatricula = <int>[];
List<String> usuSobrenome = <String>[];
List<String> usuTelefone = <String>[];

double somaDeCargaHorariaTeste = 0.0;
double somaDeCargaHorariaEstagio = 0.0;
double somaDeCargaHorariaPalestra = 0.0;
double somaDeCargaHorariaOutros = 0.0;

List<double> somasList = <double>[];

Color colorTextStyle = Color.fromRGBO(17, 17, 17, 1.0);
Color colorTextStyleTitles = Color.fromRGBO(255, 0, 0, 1.0);

List<Map<String, String>> listaDeMap = <Map<String, String>>[];

Future getDefineDadosModal() async {
  listaDeMap.clear();
  somasList.clear();
  somaDeCargaHorariaOutros = 0.0;
  somaDeCargaHorariaEstagio = 0.0;
  somaDeCargaHorariaPalestra = 0.0;

  await getMatriculaUsuario(email, usuCurso, usuEmail, usuImgPerfil,
      usuNome, usuSenha, usuNumMatricula, usuSobrenome, usuTelefone);

  final QuerySnapshot result = await Future.value(
      FirebaseFirestore.instance.collection("certificados_mhc").get());
  final List<DocumentSnapshot> documents = result.docs;

  late List<double> cargaHorariausuario = <double>[];
  late List<String> tipoCertificadousuario = <String>[];

  // Pra cada documento dentro da collection usuarios_mhc
  for (var element in documents) {
    if (usuNumMatricula.isNotEmpty &&
        element.get("cert_numero_de_matricula_usu") == usuNumMatricula[0]) {
      cargaHorariausuario
          .add(double.parse(element.get("cert_carga_horaria").toString()));
      // print("Carga Horaria: $carga_horariaUsuario");
      tipoCertificadousuario
          .add(element.get("cert_tipo_certificado").toString());
      // print("Tipo certificado: $tipo_certificadoUsuario");
    }
  }

  if (tipoCertificadousuario.length == cargaHorariausuario.length) {
    for (int i = 0; i < tipoCertificadousuario.length; i++) {
      Map<String, String> mapTemp = {};

      mapTemp['tipo_certificado'] = tipoCertificadousuario[i];
      mapTemp['carga_horaria'] = cargaHorariausuario[i].toString();

      listaDeMap.add(mapTemp);
    }

    for (int i = 0; i < listaDeMap.length; i++) {
      if (listaDeMap[i]['tipo_certificado'] == 'Outros') {
        somaDeCargaHorariaOutros +=
            double.parse(listaDeMap[i]['carga_horaria']!);
        //print('somaDeCargaHorariaOutros: $somaDeCargaHorariaOutros');
      } else if (listaDeMap[i]['tipo_certificado'] == 'Estágio') {
        somaDeCargaHorariaEstagio +=
            double.parse(listaDeMap[i]['carga_horaria']!);
        //print('somaDeCargaHorariaEstagio: $somaDeCargaHorariaEstagio');
      } else if (listaDeMap[i]['tipo_certificado'] == 'Palestra') {
        somaDeCargaHorariaPalestra +=
            double.parse(listaDeMap[i]['carga_horaria']!);
        //print('somaDeCargaHorariaPalestra: $somaDeCargaHorariaPalestra');
      }
    }
  } else {
    throw Exception('Não passou na validação');
  }

  retornarValores(somaDeCargaHorariaOutros, somaDeCargaHorariaEstagio,
      somaDeCargaHorariaPalestra);
}

void retornarValores(double somaDeCargaHorariaOutros,
    double somaDeCargaHorariaEstagio, double somaDeCargaHorariaPalestra) {
  double somaOutros = 0.0;
  double somaEstagio = 0.0;
  double somaPalestra = 0.0;

  somaOutros = somaDeCargaHorariaOutros;
  somaEstagio = somaDeCargaHorariaEstagio;
  somaPalestra = somaDeCargaHorariaPalestra;

  somasList.add(somaOutros);
  somasList.add(somaEstagio);
  somasList.add(somaPalestra);
}

Future<void> showDialogResumoCertificado(
    BuildContext context,
    List<String> tituloList,
    List<String> instituicaoList,
    List<String> coordObslist,
    List<String> imgList,
    List<double> cargaHorarialist,
    List<String> tipoCertificacaolist,
    List<String> statusList,
    int index) {
  String tempObsCoordenador = coordObslist[index];
  String tempStatus = statusList[index];

  if (coordObslist[index] == "") {
    tempObsCoordenador = "Sem observações por enquanto";
  }

  if (statusList[index] == "") {
    tempStatus = "Status indefinido";
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        //contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        title: Text(
          'Resumo',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorTextStyle, fontWeight: FontWeight.bold),
        ),
        content: Column(
          //mainAxisSize: MainAxisSize.min, --> Deixa o pop-up menor, como um quadrado, igual o da dashboard
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  child: Image.asset('images/certificado.jpg',
                      height: 200, fit: BoxFit.cover),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                height: 300,
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Titulo",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                tituloList[index],
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Instituição",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                instituicaoList[index],
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Observação do Coordenador",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                //coord_obsList[index],
                                tempObsCoordenador,
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Carga horária",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                cargaHorarialist[index].toString(),
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Tipo de certificado",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                tipoCertificacaolist[index],
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                    color: colorTextStyleTitles,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
                              Text(
                                //statusList[index],
                                tempStatus,
                                style: TextStyle(color: colorTextStyle),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                    ],
                  ),
                ))
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Fechar',
              style: TextStyle(
                  color: Color.fromRGBO(255, 0, 0, 1.0),
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Dashboard
Future<void> showDialogResumoDashboard(BuildContext context) async {
  await getDefineDadosModal();
  if (!context.mounted) return;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        title: Text(
          'Resumo',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorTextStyle, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Estágio:",
                    style: TextStyle(color: colorTextStyle),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('${somasList[1]} hrs',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: colorTextStyle)),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Outros:",
                    style: TextStyle(color: colorTextStyle),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('${somasList[0]} hrs',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: colorTextStyle)),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Palestras:",
                    style: TextStyle(color: colorTextStyle),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('${somasList[2]} hrs',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: colorTextStyle)),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Fechar',
              style: TextStyle(
                  color: Color.fromRGBO(255, 0, 0, 1.0),
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
