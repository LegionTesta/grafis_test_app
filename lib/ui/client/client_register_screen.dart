

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_register_bloc.dart';
import 'package:grafis_test_app/core/client.dart';

class ClientRegisterScreen extends StatefulWidget {
  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {

  ClientRegisterBloc _clientRegisterBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    _clientRegisterBloc = ClientRegisterBloc();
    _clientRegisterBloc.listen((state) {
      if(state is RegisteringClient){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: Text("Carregando..."),
            );
          }
        );
      }
      if(state is ClientRegistered){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("O cliente foi registrado!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
        );
        nameController.text = "";
        emailController.text = "";
      }
      if(state is ClientNotRegistered){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("O cliente não foi registrado!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo cliente"),
        ),
        body: Container(
          child: BlocBuilder(
            bloc: _clientRegisterBloc,
            builder: (BuildContext context, ClientRegisterBlocState state){
              if(state is InitialClientRegisterBlocState){
                return buildRegisterClientForm(context);
              }
              return Container();
            }
          ),
        ),
      ),
    );
  }

  Widget buildRegisterClientForm(BuildContext context){

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: "Insira o nome do cliente",
                  labelText: "Nome"
                ),
                validator: (value){
                  if(value.isEmpty)
                    return "O campo Nome não pode estar vazio";
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: "Insira o email do cliente",
                    labelText: "Email"
                ),
                validator: (value){
                  if(value.isEmpty)
                    return "O campo Email não pode estar vazio";
                  return null;
                },
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    _clientRegisterBloc.add(RegisterClient(client: Client(
                      name: nameController.text,
                      email: emailController.text
                    )));
                  }
                },
                child: Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
