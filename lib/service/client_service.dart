

import 'package:grafis_test_app/api/ClientApi.dart';
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

  ClientApi clientApi = ClientApi();

  Future<List<Client>> get() async{
    await clientApi.get();
    return null;
  }

  Future<Client> find({int id}) async{
    //TODO
  }

  Future<Client> add({Client client}) async{
    await clientApi.post(body: client.toJson());
    return null;
  }
}