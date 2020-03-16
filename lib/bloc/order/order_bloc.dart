
import 'package:bloc/bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/order.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/service/order_service.dart';

class OrderBloc extends Bloc<OrderBlocEvent, OrderBlocState>{

  OrderService orderService = OrderService.instance;

  OrderBlocState get initialState => InitialOrderBlocState();

  Stream<OrderBlocState> mapEventToState(OrderBlocEvent event) async*{
    if(event is SelectProduct){
      orderService.completeOrder.currentProduct = event.product;
      yield UpdatingOrder();
      yield SelectingAmount(completeOrder: orderService.completeOrder);
    }
    if(event is SelectClient){
      orderService.order.clientId = event.client.id;
      orderService.completeOrder.client = event.client;
      yield UpdatingOrder();
      yield OrderUpdated(completeOrder: orderService.completeOrder);
    }
    if(event is AddProduct){
      orderService.order.products.add(OrderProduct(
        productId: event.product.id,
        amount: event.amount
      ));
      orderService.completeOrder.products.add(CompleteOrderProduct(
        product: event.product,
        amount: event.amount
      ));
      orderService.completeOrder.value = orderService.calculateValue();
      orderService.completeOrder.totalValue = orderService.calculateTotalValue();
      yield UpdatingOrder();
      yield OrderUpdated(completeOrder: orderService.completeOrder);
    }
    if(event is AddDiscount){
      orderService.order.discount = event.discount;
      orderService.completeOrder.discount = event.discount;
      orderService.completeOrder.totalValue = orderService.calculateTotalValue();
      yield UpdatingOrder();
      yield OrderUpdated(completeOrder: orderService.completeOrder);
    }
    if(event is MakeOrder){
      try{
        yield MakingOrder();
        await orderService.add(order: orderService.order);
        yield OrderMade();
        yield InitialOrderBlocState();
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield OrderNotMade();
      }
    }
  }
}

abstract class OrderBlocEvent{}

class AddProduct extends OrderBlocEvent{
  final Product product;
  final double amount;

  AddProduct({this.product, this.amount});
}

class SelectProduct extends OrderBlocEvent{
  final Product product;
  SelectProduct({this.product});
}

class SelectClient extends OrderBlocEvent{
  final Client client;

  SelectClient({this.client});
}

class AddDiscount extends OrderBlocEvent{
  final double discount;
  AddDiscount({this.discount});
}

class MakeOrder extends OrderBlocEvent{}

abstract class OrderBlocState{}

class OrderUpdated extends OrderBlocState{
  final CompleteOrder completeOrder;
  OrderUpdated({this.completeOrder});
}

class UpdatingOrder extends OrderBlocState{}

class InitialOrderBlocState extends OrderBlocState{}

class MakingOrder extends OrderBlocState{}

class OrderMade extends OrderBlocState{}

class OrderNotMade extends OrderBlocState{}

class SelectingAmount extends OrderBlocState{
  final CompleteOrder completeOrder;
  SelectingAmount({this.completeOrder});
}