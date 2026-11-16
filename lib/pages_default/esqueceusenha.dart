import 'package:catolica_mhc/pages_default/login.dart';
import 'package:flutter/material.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {

  TextEditingController inputEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background da aplicação
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
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
                height: 200,
              ),

              Image.asset(
                'images/logo_mhc_branca.png',
                width: 90,
                height: 130,
              ),

              Text(
                  "Insira o e-mail abaixo para recuperar sua senha!",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Alata',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),

              Container(
                  height: 180,
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
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        controller: inputEmail,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email_outlined, size: 30, color: Colors.white),
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

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.fromLTRB(140, 15, 140, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          foregroundColor: Color(0xFF720507),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );

                        },
                        child: Text(
                          "ENVIAR",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Alata',
                              color: Color(0xFF720507),
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  )
              ),

              Container(
                  height: 222,
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
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
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
