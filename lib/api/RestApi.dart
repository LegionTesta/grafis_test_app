import 'package:http/http.dart' as http;

class RestApi<T>{

  String route, baseRoute, finalRoute;

  RestApi({this.route}){
    finalRoute = baseRoute + route;
  }

  Future<String> post({Map<String, dynamic> body}) async{
    final response = await http.post(finalRoute, body: body);
    return response.body;
  }

}