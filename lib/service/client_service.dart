

import 'package:grafis_test_app/api/client_api.dart';
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
    List<Map<String, dynamic>> clientsJson = await clientApi.get();
    print(clientsJson.length);
    List<Client> clients;
    clientsJson.forEach((element) => clients.add(Client.fromJson(element)));
    print(clients.length);
    return clients;
  }

  Future<Client> find({int id}) async{
    //TODO
  }

  Future<Client> add({Client client}) async{
    return Client.fromJson(await clientApi.post(body: client.toJson()));
  }
}