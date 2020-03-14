

import 'package:grafis_test_app/api/grafis_rest_api.dart';
import 'package:grafis_test_app/core/product.dart';

class ProductApi extends GrafisRestApi<Product>{
  ProductApi() : super(route: '/product');
}