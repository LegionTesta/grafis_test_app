

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

  @override
  void initState() {
    _clientRegisterBloc = ClientRegisterBloc();
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
              if(state is RegisteringClient){
                return buildAwaitingResponse(context);
              }
              if(state is ClientRegistered){
                return buildRegisterClientForm(context);
              }
              if(state is ClientNotRegistered){
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
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red
      ),
      child: GestureDetector(
        onTap: onTap,
      ),
    );
  }

  Widget buildAwaitingResponse(BuildContext context){
    return Text("carregando");
  }

  Widget buildClientRegistered(BuildContext context){
    return Text("foi");
  }

  Widget buildClientNotRegistered(BuildContext context){
    return Text("nao foi");
  }

  void onTap(){
    Client client = Client(name: "Teste", email: "teste@email.com");
    _clientRegisterBloc.add(RegisterClient(client: client));
  }
}
