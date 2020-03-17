
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
        Client client = await clientService.add(client: event.client);
        if(client.Message == null){
          print(client.Message);
          yield ClientRegistered();
          yield InitialClientRegisterBlocState();
        } else{
          print(client.Message);
          print(client.Message);
          yield ClientNotRegistered(msg: client.Message);
          yield InitialClientRegisterBlocState();
        }
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield ClientNotRegistered();
        yield InitialClientRegisterBlocState();
      }
    }
  }
}

abstract class ClientRegisterBlocEvent{}

class RegisterClient extends ClientRegisterBlocEvent{
  final Client client;
  RegisterClient({this.client});
}

abstract class ClientRegisterBlocState{}

class RegisteringClient extends ClientRegisterBlocState{}

class ClientRegistered extends ClientRegisterBlocState{}

class ClientNotRegistered extends ClientRegisterBlocState{
  final String msg;
  ClientNotRegistered({this.msg});
}

class InitialClientRegisterBlocState extends ClientRegisterBlocState{}