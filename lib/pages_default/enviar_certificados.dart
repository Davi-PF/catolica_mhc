import 'dart:convert';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../application/check_auth.dart';
import '../database/db_functions.dart';
import '../services/auth_service.dart';
import 'certificados.dart';
import 'notificacoes.dart';
import 'perfil.dart';

const List<String> list = <String>['Palestra', 'Estágio', 'Outros'];
// Aqui colocar dinamicamente quais são ou deixar estático, sei lá

class EnviarCertificados extends StatefulWidget {
  const EnviarCertificados({super.key});

  @override
  State<EnviarCertificados> createState() => _EnviarCertificadosState();
}

class _EnviarCertificadosState extends State<EnviarCertificados> {
  io.File? image; // Variável de armazenamento local

  // Para transformar a imagem em base64 Codificado
  late String imgBase64 = '';

  String dropDownValue = list.first;

  // modal de foto pra iOS e Android
  Future<ImageSource?> showImageSource(BuildContext context) async {
    if(io.Platform.isIOS){
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Câmera'),
                onPressed: () => pickImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Galeria'),
                onPressed: () => pickImage(ImageSource.gallery),
              ),
            ],
          )
      );
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Câmera'),
                onTap: () => pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Galeria'),
                onTap: () => pickImage(ImageSource.gallery),
              )
            ],
          )
      );
    }
  }

  Future enviarCertificados(controllerDegreeName, controllerInstitution, controllerWorkload, imgBase64, dropDownValue) async {
    var collection = FirebaseFirestore.instance.collection('certificados_mhc');
    collection.doc().set(
        {
          'usu_imagem': imgBase64,
          'usu_carga_horaria': double.parse(controllerWorkload.text),
          'usu_id': 1111,
          'usu_instituicao': controllerInstitution.text,
          'usu_motivo': "Teste",
          'usu_nome_do_curso': controllerDegreeName.text,
          'usu_numero_de_matricula': 0000,
          'usu_status': "Enviado",
          'usu_tipo_certificado': dropDownValue,
        },
      )
      .then((value) => debugPrint('Deu certo! --> ${collection.doc()}'))
      .catchError((error) => debugPrint('deu errado! $error'));
  }

  /*
   Lógica pra abrir de onde vai pegar a foto e armazenar ela na variável local
   image, definida ali em cima ^^
  */
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = io.File(image.path);

      // teste
      final bytes = io.File(image.path).readAsBytesSync();
      imgBase64 = base64Encode(bytes);

      // fim teste
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Falha na obtenção da imagem: $e');
    }
  }

  // initialize the controllers
  final TextEditingController _controllerDegreeName = TextEditingController();
  final TextEditingController _controllerInstitution = TextEditingController();
  final TextEditingController _controllerWorkload = TextEditingController();

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height;
    MediaQuery.of(context).size.width;

    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

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
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: const Text(
              'Enviar Certificado',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Pacifico'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: const Text("Certificado:",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pacifico',
                          )),
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset:
                                Offset(3, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // Image border
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(85), // Image radius
                          child: InkWell(
                            child: image != null ? Image.file(
                              image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                                    'https://placeholder.com/1920x1360?text=Adicione+o+seu+certificado...',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'images/certificado.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            onTap: () {
                              showImageSource(context);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: const Text(
                        "Dados do certificado:",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(
                                    9, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                                title: TextField(
                                  controller: _controllerDegreeName,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text('Título do certificado'),
                                    hintText: "Digite o título do certificado..."
                                  )
                                  ),
                                ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(
                                    9, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              title: TextField(
                                  controller: _controllerInstitution,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      label: Text('Instituição'),
                                      hintText: "Digite o nome da instituição..."
                                  )
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(
                                    9, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              title: TextField(
                                  controller: _controllerWorkload,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      label: Text('Carga horária'),
                                      hintText: "Digite as horas do certificado..."
                                  )
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(
                                    9, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              title: DropdownButton<String>(
                                value: dropDownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropDownValue = value!;
                                    debugPrint("Opção selecionada: $dropDownValue");
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
                      ],
                    ),
        ),
        floatingActionButton: keyboardIsOpened ? null : FloatingActionButton(
          //Floating action button on Scaffold
          onPressed: () async {
            final workload = double.tryParse(_controllerWorkload.text.replaceAll(',', '.'));
            if (workload == null ||
                _controllerDegreeName.text.trim().isEmpty ||
                _controllerInstitution.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha título, instituição e carga horária válida.'),
                ),
              );
              return;
            }
            await addCertificado(
              workload,
              'cert_img',
              _controllerInstitution.text.trim(),
              dropDownValue,
              _controllerDegreeName.text.trim(),
            );
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Certificados()),
            );
          }, //icon inside button
          backgroundColor: Color(0xFFb81317),
          child: Icon(Icons.check),
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
                                  builder: (context) => CheckAuth()));
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
}
