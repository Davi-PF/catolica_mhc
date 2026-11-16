import 'package:catolica_mhc/pages_black_mode/esqueceusenha_dm.dart';
import 'package:catolica_mhc/pages_black_mode/login_dm.dart';
import 'package:flutter/material.dart';

// Lista de cursos teste apenas para fins de estilização
const List<String> listaCursos = <String>[
  'Eng. Software',
  'Direito',
  'Nutrição',
  'Eng. Mecânica',
  'Eng. Elétrica',
  'Design',
  'Arquitetura e Urbanismo',
  'Medicina',
];

// Variável responsável pelo armazenamento do valor no Droplist
String? valorDrop;

class CadastroDM extends StatefulWidget {
  const CadastroDM({super.key});

  @override
  State<CadastroDM> createState() => _CadastroDMState();
}

class _CadastroDMState extends State<CadastroDM> {
  TextEditingController inputMatricula = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background da aplicação
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background_dark_mode.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container da imagem (Logo)
              Image.asset(
                'images/logo_catolica_branca.png',
                width: 300,
                height: 170,
              ),

              Image.asset(
                'images/logo_mhc_branca.png',
                width: 90,
                height: 100,
              ),

              Container(
                  height: 450,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  // TextFields de acesso
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        // Textfield de usuário
                        style: TextStyle(
                          fontFamily: 'Alata',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        controller: inputMatricula,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                          iconColor: Colors.white10,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          labelText: 'Número de matrícula...',
                          hoverColor: Colors.white,
                        ),
                      ),
                      TextField(
                        // Textfield de usuário
                        style: TextStyle(
                          fontFamily: 'Alata',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        controller: inputEmail,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email_outlined,
                              size: 30, color: Colors.white),
                          suffixIconColor: Colors.white,
                          iconColor: Colors.white10,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          labelText: 'E-mail...',
                          hoverColor: Colors.white,
                        ),
                      ),
                      TextField(
                        // Textfield de usuário
                        style: TextStyle(
                          fontFamily: 'Alata',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        obscureText: true,
                        controller: inputSenha,
                        decoration: InputDecoration(
                          suffixIcon:
                              Icon(Icons.lock, size: 30, color: Colors.white),
                          suffixIconColor: Colors.white,
                          iconColor: Colors.white10,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          labelText: 'Senha...',
                          hoverColor: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Escolha o seu curso",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Alada',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButton<String>(
                        value: valorDrop,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Alada',
                            fontWeight: FontWeight.bold),
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        underline: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            valorDrop = value!;
                          });
                        },
                        items: listaCursos
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.fromLTRB(125, 15, 125, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          foregroundColor: Color(0xFF720507),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeDM()),
                          );
                        },
                        child: Text(
                          "CADASTRAR",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Alata',
                              color: Color(0xFF720507),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EsqueciSenhaDM()),
                          );
                        },
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Alata'),
                        ),
                      ),
                    ],
                  )),

              Container(
                  height: 65,
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeDM()),
                      );
                    },
                    child: Text(
                      "Já possui uma conta? Faça login!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Alata',
                        fontSize: 18,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
