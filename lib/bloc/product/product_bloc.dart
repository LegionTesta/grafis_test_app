
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

    if(event is FilterProducts){
      yield LoadingProducts();
      yield ProductsFiltered(products: event.products.where((element) =>
      (element.desc.toLowerCase().contains(event.filter.toLowerCase()))
      ).toList());
    }
  }
}

abstract class ProductBlocEvent{}

class ReloadProducts extends ProductBlocEvent{}

class FilterProducts extends ProductBlocEvent{
  final String filter;
  final List<Product> products;
  FilterProducts({this.filter, this.products});
}

abstract class ProductBlocState{}

class LoadingProducts extends ProductBlocState{}

class ProductsLoaded extends ProductBlocState{
  final List<Product> products;
  ProductsLoaded({this.products});
}

class ProductsFiltered extends ProductBlocState{
  final List<Product> products;
  ProductsFiltered({this.products});
}

class ProductsNotLoaded extends ProductBlocState{}

class InitialProductBlocState extends ProductBlocState{}