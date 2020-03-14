import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApi<T>{

  String baseRoute, finalRoute;

  Map<String, String> get defaultHeaders => {
    "Content-Type": "application/json"
  };

  RestApi({String route, String baseRoute}){
    finalRoute = baseRoute + route;
  }

  Future<Map<String, dynamic>> post({Map<String, dynamic> body}) async{
    final response = await http.post(finalRoute, body: json.encode(body), headers: defaultHeaders);
    return json.decode(response.body);
  }

  Future<List<Map<String, dynamic>>> get() async{
    final response = await http.get(finalRoute, headers: defaultHeaders);
    List<dynamic> aux = json.decode(response.body) as List<dynamic>;
    List<Map<String, dynamic>> data = List();
    aux.forEach((element) => data.add(element));
    return data;
  }

}