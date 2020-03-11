
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/client.dart';

class ClientBloc extends Bloc<ClientBlocEvent, ClientBlocState>{

  ClientBlocState get initialState => InitialClientBlocState();

  @override
  Stream<ClientBlocState> mapEventToState(ClientBlocEvent event) async*{
    if(event is ReloadClients){
      try{
        yield LoadingClients();
        //TODO: clientService.getClients
        yield ClientsLoaded();
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

abstract class ClientBlocState{
  ClientBlocState({List<Client> clients});
}

class LoadingClients extends ClientBlocState{}

class ClientsLoaded extends ClientBlocState{
  final List<Client> clients;
  ClientsLoaded({this.clients});
}

class ClientsNotLoaded extends ClientBlocState{}

class InitialClientBlocState extends ClientBlocState{}