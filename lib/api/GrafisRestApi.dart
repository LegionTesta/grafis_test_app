

import 'package:grafis_test_app/api/RestApi.dart';

class GrafisRestApi<T> extends RestApi<T>{
  GrafisRestApi({String route}) : super(route: route){
    baseRoute = "http://localhost:52608/api";
  }
}