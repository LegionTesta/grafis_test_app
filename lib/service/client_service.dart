

import 'package:grafis_test_app/core/client.dart';

class ClientService{

  ClientService._();

  static ClientService  _instance;

  static ClientService get instance{
    if(_instance == null){
      _instance = ClientService._();
    }
    return _instance;
  }

  Future<List<Client>> get() async{
    //TODO
  }

  Future<Client> find({int id}) async{
    //TODO
  }

  Future<Client> add({Client client}) async{
    //TODO
  }
}