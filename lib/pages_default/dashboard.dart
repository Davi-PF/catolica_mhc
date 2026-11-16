import 'package:catolica_mhc/application/check_auth.dart';
import 'package:catolica_mhc/database/db_functions.dart';
import 'package:catolica_mhc/pages_default/enviar_certificados.dart';
import 'package:catolica_mhc/pages_default/perfil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../functions/app_logic.dart';
import '../services/auth_service.dart';
import 'certificados.dart';
import 'doughnut_chart.dart';
import 'notificacoes.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

//---------------------------------------------------------
class _DashBoardState extends State<DashBoard> {
  // Dados do estudante
  late TooltipBehavior _tooltipBehavior;

  late List<int> matriculaList = <int>[];

  late List<String> instituicaoList = <String>[];
  late List<String> imgList = <String>[];
  late List<double> cargaHorariaList = <double>[];
  late List<String> tipoCertificacaoList = <String>[];
  late List<String> statusList = <String>[];
  late double percent = 0;

  late double somaDeCargaHorariaTeste = 0.0;
  late double somaDeCargaHorariaEstagio = 0.0;
  late double somaDeCargaHorariaPalestra = 0.0;
  late double somaDeCargaHorariaOutros = 0.0;


  @override
  void initState() {
    getDefineDadosGrafico();

    getCertificadosFirebase(matriculaList, instituicaoList, imgList, cargaHorariaList, tipoCertificacaoList, statusList);
    _tooltipBehavior =
        TooltipBehavior(enable: true, textStyle: const TextStyle(fontSize: 16));
    super.initState();
  }


//---------------------------------------------------------

  List<Map<String, String>> listaDeMap = <Map<String, String>>[];
  List<ChartData> chartData = <ChartData>[];

  // Pega os dados pro gráfico e organiza
  Future getDefineDadosGrafico() async {
    await getMatriculaUsuario(email, usuCurso, usuEmail, usuImgPerfil, usuNome, usuSenha, usuNumMatricula, usuSobrenome, usuTelefone);

    final QuerySnapshot result = await Future.value(
        FirebaseFirestore.instance.collection("certificados_mhc").get());
    final List<DocumentSnapshot> documents = result.docs;

    late List<double> cargaHorariausuario = <double>[];
    late List<String> tipoCertificadousuario = <String>[];

    // Pra cada documento dentro da collection usuarios_mhc
    for (var element in documents) {
      if (usuNumMatricula.isNotEmpty &&
          element.get("cert_numero_de_matricula_usu") == usuNumMatricula[0]) {
        cargaHorariausuario.add(double.parse(element.get("cert_carga_horaria").toString()));
        // print("Carga Horaria: $carga_horariaUsuario");
        tipoCertificadousuario.add(element.get("cert_tipo_certificado").toString());
        // print("Tipo certificado: $tipo_certificadoUsuario");
      }
    }

    if(tipoCertificadousuario.length == cargaHorariausuario.length){
      for(int i = 0; i < tipoCertificadousuario.length; i++){
        Map<String, String> mapTemp = {};

        mapTemp['tipo_certificado'] = tipoCertificadousuario[i];
        mapTemp['carga_horaria'] = cargaHorariausuario[i].toString();

        listaDeMap.add(mapTemp);
      }

      for(int i = 0; i < listaDeMap.length; i++) {
        if(listaDeMap[i]['tipo_certificado'] == 'Outros'){
          somaDeCargaHorariaOutros += double.parse(listaDeMap[i]['carga_horaria']!);
          //print('somaDeCargaHorariaOutros: $somaDeCargaHorariaOutros');
        } else if(listaDeMap[i]['tipo_certificado'] == 'Estágio'){
          somaDeCargaHorariaEstagio += double.parse(listaDeMap[i]['carga_horaria']!);
          //print('somaDeCargaHorariaEstagio: $somaDeCargaHorariaEstagio');
        }
        else if(listaDeMap[i]['tipo_certificado'] == 'Palestra'){
          somaDeCargaHorariaPalestra += double.parse(listaDeMap[i]['carga_horaria']!);
          //print('somaDeCargaHorariaPalestra: $somaDeCargaHorariaPalestra');
        }
      }
    } else {
      throw Exception('Não passou na validação');
    }

    chartData = [
      ChartData("Outros", somaDeCargaHorariaOutros, Color.fromRGBO(9,0,136,1)),
      ChartData("Estágio", somaDeCargaHorariaEstagio, Color.fromRGBO(147,0,119,1)),
      ChartData("Palestra", somaDeCargaHorariaPalestra, Color.fromRGBO(228,0,124,1)),
    ];

    percent = calcularHorasFaltantes(somaDeCargaHorariaOutros, somaDeCargaHorariaEstagio, somaDeCargaHorariaPalestra);

    if (mounted) {
      setState(() {});
    }
  }
  
  // Pega os dados do certificado
  Future getCertificadosFirebase(List<int> matriculaList,List<String> instituicaoList, List<String> imgList, List<double> cargaHorarialist, List<String> tipoCertificacaolist, List<String> statusList) async {

    final QuerySnapshot result = await Future.value(FirebaseFirestore.instance.collection("certificados_mhc").get()); //.limit(1).

    final List<DocumentSnapshot> documents = result.docs;

    late int matriculaCertificado;

    late String instituicao;
    late String img;
    late double cargaHoraria;
    late String tipoCertificacao;
    late String status;

    for (var element in documents) {
      matriculaCertificado = element.get("cert_numero_de_matricula_usu");
      matriculaList.add(matriculaCertificado);

      instituicao = element.get("cert_instituicao").toString();
      instituicaoList.add(instituicao);

      img = element.get("cert_img").toString();
      imgList.add(img);

      cargaHoraria = double.parse(element.get("cert_carga_horaria").toString());
      cargaHorarialist.add(cargaHoraria);

      status = element.get("cert_status").toString();
      statusList.add(status);

      tipoCertificacao = element.get("cert_tipo_certificado").toString();
      tipoCertificacaolist.add(tipoCertificacao);
    }
  }

  double calcularHorasFaltantes(double somaDeCargaHorariaOutros, double somaDeCargaHorariaEstagio, double somaDeCargaHorariaPalestra){
    double somaDasHoras = 0;
    double horasFaltantes = 0;
    double porcentagem = 0;

    somaDasHoras = somaDeCargaHorariaOutros + somaDeCargaHorariaEstagio + somaDeCargaHorariaPalestra;
    //print('somaDasHoras: $somaDasHoras');
    horasFaltantes = (somaDasHoras*100/238)/100;
    //print('horasFaltantes; $horasFaltantes');
    porcentagem = horasFaltantes;
    //print('porcentagem: $porcentagem');

    return porcentagem;
  }

  // Construção da dash
  @override
  Widget build(BuildContext context) {
    double valorTextoProgress = percent * 100;
    late String textoProgressBar = valorTextoProgress.toStringAsFixed(1);

    //addCertificado();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                AuthService.to.logout();
              },
            ),
            PopupMenuButton(
                iconSize: 10,
                icon: Image.asset("images/user_icon.png",
                    width: 80, height: 35),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: 0, child: Text('Logout')),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckAuth()));
                    AuthService.to.logout();
                  }
                })
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  alignment: FractionalOffset.topLeft,
                  margin: EdgeInsets.only(left: 40, top: 20, bottom: 15),
                  child: usuNome.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          "Olá,\n${usuNome.first} ${usuSobrenome.first}",
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        )),
              Container(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  "Suas Estatísticas",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                    textStyle: TextStyle(fontSize: 14),
                  ),
                  // Legenda abaixo do gráfico (default: direita)
                  tooltipBehavior: _tooltipBehavior,
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 70,
                          onPressed: () {
                            showDialogResumoDashboard(context);
                          },
                          icon: const Icon(
                            Icons.pending_actions,
                            size: 50,
                            color: Color.fromRGBO(255, 255, 255, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                  series: <CircularSeries>[
                    // Renders doughnut chart
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      radius: '100%',

                      dataLabelSettings: DataLabelSettings(
                        isVisible: false,
                        offset: Offset.fromDirection(1),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      enableTooltip: true,
                      //Liberando modificações Tooltip

                      explode:
                          true, //Clicar no gráfico destaca a sua estatística
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 23),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * 0.8,
                      animation: true,
                      alignment: MainAxisAlignment.center,
                      barRadius: Radius.circular(10),
                      lineHeight: 20.0,
                      animationDuration: 2500,
                      percent: percent < 0 ? percent = 0 :
                               percent > 1 ? percent = 1 : percent,
                      center: Text(
                        '$textoProgressBar%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      progressColor: Colors.green,
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.green, shape: BoxShape.circle),
                  //   child: IconButton(
                  //     iconSize: 70,
                  //     onPressed: () {
                  //       ShowDialogResumo(context);
                  //     },
                  //     icon: Icon(Icons.pending_actions, size: 50,
                  //         color: Color.fromRGBO(255, 255, 255, 1.0)),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        //Floating action button on Scaffold
        onPressed: () {
          //code to execute on button press
          _showModal(context);
        }, //icon inside button
        backgroundColor: Color(0xFFb81317),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            //bottom navigation bar on scaffold
            color: Colors.transparent,
            shape: const CircularNotchedRectangle(),
            //shape of notch
            notchMargin: 5,
            clipBehavior: Clip.antiAlias,
            //notche margin between floating button and bottom appbar
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFb81317), Color(0xFF720507)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  stops: [0.1, 0.8],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Dashboard
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckAuth()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Certificados()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.analytics,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notificacoes()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Perfil()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Modal Enviar certificado
  void _showModal(BuildContext context) {
    //code to execute on button press
    //botao aparece as coisas
    showModalBottomSheet<void>(
      context: context,
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                        Icon(Icons.add_chart_sharp),
                        Text("Inserir certificado     ",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnviarCertificados()));
                    },
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
  }
}
