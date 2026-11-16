import 'package:catolica_mhc/database/db_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../application/check_auth.dart';
import '../functions/app_logic.dart';
import '../services/auth_service.dart';
import 'enviar_certificados.dart';
import 'perfil.dart';

import 'certificados.dart';

int indexDoCertificadoSelecionadoNotificacoes = 0;

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {

  late List<int> idListNotificacoes = <int>[];
  late List<String> tituloList = <String>[];
  late List<String> situacaoList = <String>[];
  late List<int> numeroDeMatriculaUsuList = <int>[];

  late int selectedOption = numeroDeMatriculaUsuList.length + 1;

  @override
  void initState() {
    getCertificadosFirebase(idListNotificacoes, tituloList, situacaoList,
        numeroDeMatriculaUsuList);
    super.initState();
  }

  Future getCertificadosFirebase(
    List<int> idListNotificacoes,
    List<String> tituloList,
    List<String> situacaoList,
    List<int> numeroDeMatriculaUsulist,
  ) async {
    await getMatriculaUsuario(email, usuCurso, usuEmail, usuImgPerfil, usuNome,
        usuSenha, usuNumMatricula, usuSobrenome, usuTelefone);

    final QuerySnapshot result = await Future.value(FirebaseFirestore.instance.collection("certificados_mhc").get());

    final List<DocumentSnapshot> documents = result.docs;

    late int idNotificacoes;
    late String titulo;
    late int numeroDeMatriculaUsu;
    late String situacao;

    for (var element in documents) {
      if (usuNumMatricula.isNotEmpty &&
          element.get('cert_numero_de_matricula_usu') == usuNumMatricula[0]) {
        idNotificacoes = element.get('cert_id');
        idListNotificacoes.add(idNotificacoes);

        titulo = element.get("cert_titulo").toString();
        tituloList.add(titulo);

        numeroDeMatriculaUsu = element.get("cert_numero_de_matricula_usu");
        numeroDeMatriculaUsulist.add(numeroDeMatriculaUsu);

        situacao = element.get("cert_situacao_do_certificado").toString();
        situacaoList.add(situacao);
      }
    }
    if (mounted) {
      setState(() {
        selectedOption = numeroDeMatriculaUsulist.length+1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height;
    MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
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
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: const Text(
                  'Notificações',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: numeroDeMatriculaUsuList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(situacaoList[index] != "Pendente"){
                          return InkWell(
                            child: SizedBox(
                              height: 110,
                              width: 400,
                              child: Container(
                                  width: double.maxFinite,
                                  //height: 65.0,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                        style: BorderStyle.solid),
                                    color: const Color(0xFFDFDFDF),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(3, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                        child: Image.asset("images/warning.png",
                                            width: 15, height: 15),
                                      ),
                                      SizedBox(
                                          width: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Certificado "${tituloList[index]}"',
                                                  style: TextStyle(color: colorTextStyle, fontSize: 15),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 2)),
                                                Text(
                                                  situacaoList[index],
                                                  style: TextStyle(color: Colors.red, fontSize: 15),
                                                  textAlign: TextAlign.start,
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  )),
                            ),
                            onTap: () async {
                              indexDoCertificadoSelecionadoNotificacoes = index;
                              await alterarSituacaoCertificado(idListNotificacoes);
                              if (!context.mounted) return;
                              setState(() {});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Notificacoes()));
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }
                  )
                ],
              ),
            ],
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CheckAuth())
                            );
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
                              MaterialPageRoute(builder: (context) => Certificados())
                          );
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
                              MaterialPageRoute(builder: (context) => Notificacoes())
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Perfil())
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )));
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