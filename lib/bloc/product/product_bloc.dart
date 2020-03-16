
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/service/product_service.dart';

class ProductBloc extends Bloc<ProductBlocEvent, ProductBlocState>{

  ProductService productService = ProductService.instance;

  ProductBlocState get initialState => InitialProductBlocState();

  @override
  Stream<ProductBlocState> mapEventToState(ProductBlocEvent event) async*{
    if(event is ReloadProducts){
      try{
        yield LoadingProducts();
        var products = await productService.get();
        yield ProductsLoaded(products: products);
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield ProductsNotLoaded();
      }
    }
  }
}

abstract class ProductBlocEvent{}

class ReloadProducts extends ProductBlocEvent{}

abstract class ProductBlocState{}

class LoadingProducts extends ProductBlocState{}

class ProductsLoaded extends ProductBlocState{
  final List<Product> products;
  ProductsLoaded({this.products});
}

class ProductsNotLoaded extends ProductBlocState{}

class InitialProductBlocState extends ProductBlocState{}