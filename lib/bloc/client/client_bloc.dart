
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/service/client_service.dart';

class ClientBloc extends Bloc<ClientBlocEvent, ClientBlocState>{

  ClientService clientService = ClientService.instance;

  ClientBlocState get initialState => InitialClientBlocState();

  @override
  Stream<ClientBlocState> mapEventToState(ClientBlocEvent event) async*{
    if(event is ReloadClients){
      try{
        yield LoadingClients();
        var clients = await clientService.get();
        yield ClientsLoaded(clients: clients);
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield ClientsNotLoaded();
      }
    }
  }
}

abstract class ClientBlocEvent{}

class ReloadClients extends ClientBlocEvent{}

abstract class ClientBlocState{}

class LoadingClients extends ClientBlocState{}

class ClientsLoaded extends ClientBlocState{
  final List<Client> clients;
  ClientsLoaded({this.clients});
}

class ClientsNotLoaded extends ClientBlocState{}

class InitialClientBlocState extends ClientBlocState{}