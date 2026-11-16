import 'dart:io';

import 'package:catolica_mhc/database/db_functions.dart';
import 'package:catolica_mhc/funcionalidades/cruds/entities/usuarios_crud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../application/check_auth.dart';
import '../functions/app_logic.dart';
import '../functions/image_widget.dart';
import '../services/auth_service.dart';
import 'certificados.dart';
import 'enviar_certificados.dart';
import 'notificacoes.dart';

Widget buildCircle({
  required Widget child,
  required double all,
  required Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );

Widget buildEditIcon(Color color) => buildCircle(
      color: Colors.white,
      all: 2,
      child: buildCircle(
        color: color,
        all: 5,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 18,
        ),
      ),
    );

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Icon iconeFloatingButton = Icon(Icons.add);
  bool _activateFieldPhone = false;
  File? image; // Variável de armazenamento local

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

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
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
              ));
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
              ));
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Falha na obtenção da imagem: $e');
    }
  }

  UsuariosCrud user = UsuariosCrud(
      0,
      // ^^ Matricula
      usuNome.isNotEmpty ? usuNome[0] : '',
      usuSobrenome.isNotEmpty ? usuSobrenome[0] : '',
      email ?? '',
      usuSenha.isNotEmpty ? usuSenha[0] : '',
      usuCurso.isNotEmpty ? usuCurso[0] : '',
      usuTelefone.isNotEmpty ? usuTelefone[0] : '',
      usuImgPerfil.isNotEmpty ? usuImgPerfil[0] : '');

  Future<UsuariosCrud> getDataUser() async {
    await getMatriculaUsuario(email, usuCurso, usuEmail, usuImgPerfil,
        usuNome, usuSenha, usuNumMatricula, usuSobrenome, usuTelefone);
    user = UsuariosCrud(
      usuNumMatricula.isNotEmpty ? usuNumMatricula[0] : 0,
      usuNome.isNotEmpty ? usuNome[0] : '',
      usuSobrenome.isNotEmpty ? usuSobrenome[0] : '',
      email ?? '',
      usuSenha.isNotEmpty ? usuSenha[0] : '',
      usuCurso.isNotEmpty ? usuCurso[0] : '',
      usuTelefone.isNotEmpty ? usuTelefone[0] : '',
      usuImgPerfil.isNotEmpty ? usuImgPerfil[0] : '',
    );
    _controllerPhone.text = user.usoTelefone;
    _controllerEmail.text = user.usuEmail;
    _controllerPassword.text = user.usuSenha;
    if (mounted) {
      setState(() {});
    }
    return user;
  }

  // initialize the controllers
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataUser();
    _controllerPhone.text = user.usoTelefone;
    _controllerEmail.text = user.usuEmail;
    _controllerPassword.text = user.usuSenha;
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(0xFFC0090C);
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckAuth()));
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
              'Perfil',
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
              image != null
                  ? ImageWidget(
                      image: image!,
                      onClicked: (source) => pickImage(source))
                  : InkWell(
                      child: Stack(
                        children: [
                          Transform.scale(
                            scale: 1.1,
                            child: CircleAvatar(
                                backgroundColor: Color(0xFF720507),
                                radius: 50.0,
                                backgroundImage:
                                    AssetImage('images/user_icon.png')),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: buildEditIcon(color),
                          )
                        ],
                      ),
                      onTap: () => showImageSource(context)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "${user.usuNome} ${user.usuSobrenome}",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
              Text(
                user.usuCurso,
                /*esse ??"" significa que se n tiver valor, ele deixa nulo*/
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontFamily: 'Source Sans Pro',
                ),
              ),
              SizedBox(
                  height: 20.0,
                  child: Divider(
                      color: Color(0xFF720507) /*Color(0xFFb81317),*/
                      )),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Color(0xFF720507),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          onChanged: (String value) =>
                              iconeFloatingButton = Icon(Icons.edit),
                          controller: _controllerPhone,
                          obscureText: false,
                          enabled: _activateFieldPhone,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text('Telefone'),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (_activateFieldPhone == false) {
                                _activateFieldPhone = true;
                              } else if (_activateFieldPhone == true &&
                                  _controllerPhone.text !=
                                      user.usoTelefone) {
                                _activateFieldPhone = true;
                                iconeFloatingButton = Icon(Icons.edit);
                              } else {
                                _activateFieldPhone = false;
                                iconeFloatingButton = Icon(Icons.add);
                              }
                            });
                          },
                          icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Color(0xFF720507),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _controllerEmail,
                          obscureText: false,
                          enabled: false,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text('Email'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.lock,
                        color: Color(0xFF720507),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _controllerPassword,
                              obscureText: true,
                              enabled: false,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                label: Text('Senha'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
                      ],
                    ),
        ),
        floatingActionButton: keyboardIsOpened
            ? null
            : FloatingActionButton(
                //Floating action button on Scaffold
                onPressed: () {
                  //code to execute on button press

                  // Segurança de edição
                  if (_controllerPhone.text != user.usoTelefone) {
                    _activateFieldPhone = false;
                    setState(() {});
                    editarPerfil(_controllerPhone.text);
                  } else {
                    _showModal(context);
                  }
                }, //icon inside button
                backgroundColor: Color(0xFFb81317),
                child: iconeFloatingButton,
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

  @override
  void dispose() {
    _controllerPhone.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
