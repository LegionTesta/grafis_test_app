

import 'package:grafis_test_app/api/GrafisRestApi.dart';
import 'package:grafis_test_app/core/client.dart';

class ClientApi extends GrafisRestApi<Client>{
  ClientApi() : super(route: "/client");
}