import 'package:catolica_mhc/database/db_functions.dart';
import 'package:catolica_mhc/funcionalidades/cruds/entities/CertificadosCrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../application/checkAuth.dart';
import '../database/db_firestore.dart';
import '../functions/appLogic.dart';
import '../services/auth_service.dart';
import 'dashBoard.dart';
import 'enviarCertificados.dart';
import 'login.dart';
import 'notificacoes.dart';
import 'perfil.dart';
int indexDoCertificadoSelecionadoCertificados = 0;

class Certificados extends StatefulWidget {
  const Certificados({Key? key}) : super(key: key);

  @override
  State<Certificados> createState() => _CertificadosState();
}

class _CertificadosState extends State<Certificados> {

  late List<int> idListCertificados = <int>[];
  Color colorTextStyle = Color.fromRGBO(17, 17, 17, 1.0);
  Color colorTextStyle_titles = Color.fromRGBO(255, 0, 0, 1.0);

  late List<String> tituloList = <String>[];
  late List<String> instituicaoList = <String>[];
  late List<String> imgList = <String>[];
  late List<double> carga_horariaList = <double>[];
  late List<String> tipo_certificacaoList = <String>[];
  late List<String> statusList = <String>[];
  late List<String> coord_obsList = <String>[];
  late List<String> situacaoList = <String>[];

  late int selectedOption = imgList.length + 1;
  late int selectedOption2 = imgList.length + 1;
  late Color corCaixaCertificados = Colors.white24;
  late bool modal2 = false;
  late IconData iconModal = Icons.add;

  void ShowModal2(BuildContext context) {
    //code to execute on button press
    //botao aparece as coisas
    showModalBottomSheet<void>(
      context: context,

      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(50)
        ),
      ),
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
                          Text("Deletar certificado     ",
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      onPressed: () {
                          deletarCertificado(idListCertificados);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Certificados()));
                      },
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: StadiumBorder(),
                          minimumSize: Size(300, 43),
                          maximumSize: Size(300, 43),
                          backgroundColor: Colors.red[900]),
                      child: Text("Cancelar", style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        setState(() {
                          modal2 = false;
                          iconModal = Icons.add;
                          selectedOption2 = imgList.length + 1;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getCertificadosFirebase(
        idListCertificados,
        tituloList,
        instituicaoList,
        coord_obsList,
        imgList,
        carga_horariaList,
        tipo_certificacaoList,
        statusList,
        situacaoList);
    super.initState();
  }

  Future getCertificadosFirebase(
      List<int> idListCertificados, List<String> tituloList,
      List<String> instituicaoList, List<String> coord_obsList,
      List<String> imgList, List<double> carga_horariaList,
      List<String> tipo_certificacaoList, List<String> statusList,
      List<String> situacaoList) async {

    await getMatriculaUsuario(email, usu_curso, usu_email, usu_img_perfil, usu_nome, usu_senha, usu_num_matricula, usu_sobrenome, usu_telefone);

    FirebaseFirestore db = await DBFirestore.get();
    final QuerySnapshot result = await db.collection("certificados_mhc").get();
    final List<DocumentSnapshot> documents = result.docs;

    late int id_certificado;
    late String titulo;
    late String img;
    late double carga_horaria;
    late String tipo_certificacao;
    late String status;
    late String instituicao;
    late String coord_obs;
    late String situacao;

    documents.forEach((element) {
      if(element.get('cert_numero_de_matricula_usu') == usu_num_matricula[0]){
        id_certificado = element.get("cert_id") ?? 0;
        idListCertificados.add(id_certificado);

        titulo = element.get("cert_titulo").toString() ?? '';
        tituloList.add(titulo);

        img = element.get("cert_img").toString() ?? '';
        imgList.add(img);

        instituicao = element.get("cert_instituicao").toString() ?? '';
        instituicaoList.add(instituicao);

        coord_obs = element.get("cert_coord_obs").toString() ?? '';
        coord_obsList.add(coord_obs);

        carga_horaria =
            double.parse(element.get("cert_carga_horaria").toString() ?? '');
        carga_horariaList.add(carga_horaria);

        status = element.get("cert_status").toString() ?? '';
        statusList.add(status);

        tipo_certificacao = element.get("cert_tipo_certificado").toString() ?? '';
        tipo_certificacaoList.add(tipo_certificacao);

        situacao = element.get("cert_situacao_do_certificado").toString() ?? '';
        situacaoList.add(situacao);
      }
    });
    setState(() {
      selectedOption = imgList.length + 1;
      selectedOption2 = imgList.length + 1;
    });
  }

  changeIcon(index) {
    if (selectedOption2 == index && selectedOption == imgList.length + 1) {
      return iconModal = Icons.edit;
    } else {
      return iconModal = Icons.add;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

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
              Container(
                child: PopupMenuButton(
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
                  }),
              )
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: const Text(
                    'Certificados',
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
                        itemCount: instituicaoList.length,
                        itemBuilder: (BuildContext context, int index) {

                          return SizedBox(
                            child: InkWell(
                              child: Container(
                                  width: double.maxFinite,
                                  height: 130.0,
                                  // ----> Sem o height ele deixa a caixa do tamanho que os componentem ocuparem, se utilizar ele trava o tamanho conforme o digitado
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                        style: BorderStyle.solid),
                                    color: selectedOption == index &&
                                        selectedOption2 == imgList.length + 1
                                        ? Colors.cyan
                                        :
                                    selectedOption == imgList.length + 1 &&
                                        selectedOption2 == index ? Colors
                                        .yellowAccent :
                                    Colors.white24,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset:
                                        Offset(
                                            3, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              0, 0, 12, 0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            // Image border
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(55),
                                              // Image radius
                                              child: Image.asset(
                                                'images/certificado.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                      ),
                                      Container(
                                          width: 170,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 5),
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Titulo",
                                                          style: TextStyle(
                                                              color: colorTextStyle_titles,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 15),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 3)
                                                        ),
                                                        Text(
                                                          tituloList[index],
                                                          style: TextStyle(
                                                              color: colorTextStyle),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 5),
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Carga horária",
                                                          style: TextStyle(
                                                              color: colorTextStyle_titles,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 15),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 3)
                                                        ),
                                                        Text(
                                                          carga_horariaList[index]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: colorTextStyle),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 5),
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Situação",
                                                          style: TextStyle(
                                                              color: colorTextStyle_titles,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 15),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 3)
                                                        ),
                                                        Text(
                                                          situacaoList[index],
                                                          style: TextStyle(
                                                              color: colorTextStyle),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 5),
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Status",
                                                          style: TextStyle(
                                                              color: colorTextStyle_titles,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 15),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 3)
                                                        ),
                                                        Text(
                                                          //statusList[index],
                                                          statusList[index],
                                                          style: TextStyle(
                                                              color: colorTextStyle),
                                                          textAlign: TextAlign
                                                              .start,
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      Stack(
                                        children: [
                                          Positioned(
                                              child: IconButton(
                                                  icon: const Icon(Icons
                                                      .delete_forever_rounded,
                                                      size: 30),
                                                  onPressed: () {
                                                    indexDoCertificadoSelecionadoCertificados = index;
                                                    setState(() {
                                                      selectedOption2 = index;
                                                      selectedOption =
                                                          imgList.length + 1;
                                                      modal2 = true;

                                                      if (modal2 == true &&
                                                          selectedOption2 ==
                                                              index) {
                                                        changeIcon(index);
                                                      }
                                                    });
                                                  }
                                              ))
                                        ],
                                      )
                                    ],
                                  )),
                              onTap: () {
                                setState(() {
                                  selectedOption = index;
                                  selectedOption2 = imgList.length + 1;
                                  changeIcon(index);
                                  corCaixaCertificados =
                                  selectedOption == imgList.length + 1 &&
                                      selectedOption2 == imgList.length + 1
                                      ? Colors.white24
                                      : Colors.cyan;
                                  ShowDialogResumoCertificado(
                                      context,
                                      tituloList,
                                      instituicaoList,
                                      coord_obsList,
                                      imgList,
                                      carga_horariaList,
                                      tipo_certificacaoList,
                                      statusList,
                                      index);
                                });
                              },
                            ),
                          );
                        }
                    )
                  ],
                ),
              ],
            ), // --------------------------------------------------------------------------------------------------
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //Floating action button on Scaffold
          onPressed: () {
            //code to execute on button press
            if (iconModal == Icons.add) {
              ShowModal(context);
            }
            if (iconModal == Icons.edit) {
              ShowModal2(context);
            }
          },
          child: Icon(iconModal), //Icons.edit : Icons.add
          //icon inside button
          backgroundColor: Color(0xFFb81317),
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
                              MaterialPageRoute(
                                  builder: (context) => DashBoard()));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {});
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Perfil()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  // Modal Enviar certificado
  void ShowModal(BuildContext context) {
    //code to execute on button press
    //botao aparece as coisas
    showModalBottomSheet<void>(
      context: context,

      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(50)
        ),
      ),
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
                                builder: (context) => EnviarCertificados())
                        );
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
                        Text("Escanear certificado", style: TextStyle(
                            fontSize: 20),),
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