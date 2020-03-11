
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/service/client_service.dart';

class ClientRegisterBloc extends Bloc<ClientRegisterBlocEvent, ClientRegisterBlocState>{

  ClientService clientService = ClientService.instance;

  ClientRegisterBlocState get initialState => InitialClientRegisterBlocState();

  @override
  Stream<ClientRegisterBlocState> mapEventToState(ClientRegisterBlocEvent event) async*{
    if(event is RegisterClient){
      try{
        yield RegisteringClient();
        await clientService.add(client: event.client);
        yield ClientRegistered();
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield ClientNotRegistered();
      }
    }
  }
}

abstract class ClientRegisterBlocEvent{
  ClientRegisterBlocEvent({Client client});
}

class RegisterClient extends ClientRegisterBlocEvent{
  final Client client;
  RegisterClient({this.client});
}

abstract class ClientRegisterBlocState{}

class RegisteringClient extends ClientRegisterBlocState{}

class ClientRegistered extends ClientRegisterBlocState{}

class ClientNotRegistered extends ClientRegisterBlocState{}

class InitialClientRegisterBlocState extends ClientRegisterBlocState{}