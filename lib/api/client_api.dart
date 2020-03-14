

import 'package:grafis_test_app/api/grafis_rest_api.dart';
import 'package:grafis_test_app/core/client.dart';

class ClientApi extends GrafisRestApi<Client>{
  ClientApi() : super(route: '/client');
}