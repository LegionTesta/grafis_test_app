
import 'package:grafis_test_app/api/product_api.dart';
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

  ProductApi productApi = ProductApi();

  Future<List<Product>> get() async{
    List<Map<String, dynamic>> productsJson = await productApi.get();
    List<Product> products = List();
    productsJson.forEach((element) => products.add(Product.fromJson(element)));
    return products;
  }

  Future<Product> add({Product product}) async{
    return Product.fromJson(await productApi.post(body: product.toJson()));
  }
}