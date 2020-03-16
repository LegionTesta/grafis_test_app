
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
    List<Client> clients = List();
    clientsJson.forEach((element) => clients.add(Client.fromJson(element)));
    return clients;
  }

  Future<Client> add({Client client}) async{
    return Client.fromJson(await clientApi.post(body: client.toJson()));
  }
}