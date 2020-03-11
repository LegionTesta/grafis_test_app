

import 'package:grafis_test_app/core/product.dart';

class ProductService{

  ProductService._();

  static ProductService  _instance;

  static ProductService get instance{
    if(_instance == null){
      _instance = ProductService._();
    }
    return _instance;
  }

  Future<List<Product>> get() async{
    //TODO
  }

  Future<Product> find({int id}) async{
    //TODO
  }

  Future<Product> add({Product Product}) async{
    //TODO
  }
}