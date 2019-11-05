import 'dart:io';

import 'package:aplicativo_shareon/models/usuario_model.dart';
import 'package:aplicativo_shareon/telas/tela_CadastroUsuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final campos = GlobalKey<FormState>();
  final verificacao = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return alertExit(context);
      },
      child: Scaffold(
          key: verificacao,
          appBar: AppBar(
            title: Text("Entrar"),
            centerTitle: true,
          ),
          body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.carregando)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return Container(
                padding: EdgeInsets.all(16),
                height: double.infinity,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: 260,
                      ),
                      child: Form(
                        key: campos,
                        child: ListView(
                          children: <Widget>[
                            TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "E-mail",
                                  icon: Icon(
                                    Icons.mail,
                                    color: Colors.indigo,
                                  ),
                                ),
                                validator: (valor) {
                                  if (valor.isEmpty) {
                                    return "Campo Email obrigatório";
                                  } else if (!valor.contains("@")) {
                                    return "Digite um email válido";
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Senha",
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.indigo,
                                  )),
                              validator: (valor) {
                                if (valor.isEmpty) {
                                  return "Campo Senha obrigatório";
                                } else if (valor.length < 6) {
                                  return "Senha curta, mínimo 6 digitos";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: () {
                                  if (emailController.text.isEmpty)
                                    verificacao.currentState.showSnackBar(SnackBar(
                                      content: Text("Insira seu e-mail para recuperação"),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    ));
                                  else {
                                    model.recoverPass(emailController.text);
                                    verificacao.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          "Um e-mail de confirmação foi enviado no seu endereço de e-mail."),
                                      backgroundColor: Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                },
                                child: Text(
                                  "Esqueci minha senha",
                                  textAlign: TextAlign.right,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 44,
                              child: RaisedButton(
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (campos.currentState.validate()) {}

                                  model.signIn(
                                      email: emailController.text,
                                      pass: passController.text,
                                      onSuccess: _onSuccess,
                                      onFail: _onFail);
                                },
                              ),
                            ),
                            FlatButton(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  "Novo por aqui? Cadastre-se",
                                  style: TextStyle(fontSize: 15, color: Colors.indigo),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => CadastroUsuario()));
                                })
                          ],
                        ),
                      ),
                    
                ),
                  ),
              );
            },
          )),
    );
  }

  void _onSuccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  void _onFail() {
    verificacao.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  alertExit(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: GestureDetector(
                  onTap: () => null,
                  child: Container(
                    color: Colors.white,
                    height: 120,
                    width: 300,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Sair",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Text(
                            "Deseja mesmo sair do app?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.indigo,
                              margin: EdgeInsets.only(
                                top: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: RaisedButton(
                                        color: Colors.indigo,
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            exit(0);
                                          });
                                        },
                                        child: Text(
                                          "Sair",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: RaisedButton(
                                        color: Colors.indigo,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "voltar",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
