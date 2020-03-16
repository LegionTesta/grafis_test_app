
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_register_bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/ui/menu_drawer.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {

  ClientBloc _clientBloc;
  ClientRegisterBloc _clientRegisterBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    _clientBloc = ClientBloc();
    _clientBloc.add(ReloadClients());
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
        _clientBloc.add(ReloadClients());
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
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Text("Clientes"),
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              BlocBuilder(
                  bloc: _clientBloc,
                  builder: (BuildContext context, ClientBlocState state){
                    if(state is LoadingClients){
                      return Center(
                        child: Text("Carregando clientes..."),
                      );
                    }
                    if(state is ClientsLoaded){
                      return buildClientsList(context, state.clients);
                    }
                    return Container();
                  }
              ),
              BlocBuilder(
                  bloc: _clientRegisterBloc,
                  builder: (BuildContext context, ClientRegisterBlocState state){
                    if(state is InitialClientRegisterBlocState){
                      return buildRegisterClientForm(context);
                    }
                    return Container();
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClientsList(BuildContext context, List<Client> clients){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (BuildContext context, index){
            return Card(
              child: ListTile(
                title: Text(clients[index].name),
                subtitle: Text(clients[index].email),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget buildRegisterClientForm(BuildContext context){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
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
                      return "Campo Nome vazio.";
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
                      return "Campo Email vazio.";
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
      ),
    );
  }
}
