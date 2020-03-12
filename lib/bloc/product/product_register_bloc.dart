
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/service/product_service.dart';

class ProductRegisterBloc extends Bloc<ProductRegisterBlocEvent, ProductRegisterBlocState>{

  ProductService productService = ProductService.instance;

  ProductRegisterBlocState get initialState => InitialProductRegisterBlocState();

  @override
  Stream<ProductRegisterBlocState> mapEventToState(ProductRegisterBlocEvent event) async*{
    if(event is RegisterProduct){
      try{
        yield RegisteringProduct();
        await productService.add(product: event.product);
        yield ProductRegistered();
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield ProductNotRegistered();
      }
    }
  }
}

abstract class ProductRegisterBlocEvent{
  ProductRegisterBlocEvent({Product product});
}

class RegisterProduct extends ProductRegisterBlocEvent{
  final Product product;
  RegisterProduct({this.product});
}

abstract class ProductRegisterBlocState{}

class RegisteringProduct extends ProductRegisterBlocState{}

class ProductRegistered extends ProductRegisterBlocState{}

class ProductNotRegistered extends ProductRegisterBlocState{}

class InitialProductRegisterBlocState extends ProductRegisterBlocState{}