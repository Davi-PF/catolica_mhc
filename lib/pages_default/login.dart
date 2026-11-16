import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController inputLogin = TextEditingController();
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

              Container(
                  height: 460,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  // TextFields de acesso
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              // Textfield de usuário
                              style: TextStyle(
                                fontFamily: 'Alata',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              controller: inputLogin,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.5)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.5)),
                                labelText: 'Digite o seu email...',
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
                              onSubmitted: (text) {
                                AuthService.to
                                    .login(inputLogin.text, inputSenha.text);
                              },
                              cursorColor: Colors.white,
                              obscureText: true,
                              controller: inputSenha,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                suffixIconColor: Colors.white,
                                iconColor: Colors.white10,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.5)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.5)),
                                labelText: 'Digite a sua senha...',
                                hoverColor: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                AuthService.to
                                    .login(inputLogin.text, inputSenha.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.fromLTRB(140, 15, 140, 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                foregroundColor: Color(0xFF720507),
                              ),
                              child: Text(
                                "ENTRAR",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Alata',
                                    color: Color(0xFF720507),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
