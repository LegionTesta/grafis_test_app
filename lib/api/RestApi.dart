import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApi<T>{

  String baseRoute, finalRoute;

  Map<String, String> get defaultHeaders => {
    "Content-Type": "application/json"
  };

  RestApi({String route, String baseRoute}){
    finalRoute = baseRoute + route;
    print(finalRoute);
  }

  Future<String> post({Map<String, dynamic> body}) async{
    print("post");
    print(body.toString());
    final response = await http.post(finalRoute, body: json.encode(body), headers: defaultHeaders);
    print(response.body.toString());
    return response.body;
  }

  Future<String> get() async{
    print("get");
    final response = await http.get(finalRoute);
    print(response.body.toString());
    return response.body;
  }

}