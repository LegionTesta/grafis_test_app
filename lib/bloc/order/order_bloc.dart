
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
      if(orderService.order.products == null)
        orderService.order.products = List<OrderProduct>();
      orderService.order.products.add(OrderProduct(
        productId: event.product.id,
        amount: event.amount
      ));
      if(orderService.completeOrder.products == null)
        orderService.completeOrder.products = List<CompleteOrderProduct>();
      orderService.completeOrder.products.add(CompleteOrderProduct(
        product: event.product,
        amount: event.amount
      ));
      orderService.completeOrder.value = orderService.calculateValue();
      orderService.completeOrder.totalValue = orderService.calculateTotalValue();
      orderService.completeOrder.currentProduct = null;
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
        if(orderService.completeOrder.value == null || orderService.completeOrder.value <= 0) {
          yield OrderNotMade(msg: "Nenhum item inserido.");
          yield InitialOrderBlocState(completeOrder: orderService.completeOrder);
        } else if(orderService.completeOrder.client == null) {
          yield OrderNotMade(msg: "Cliente não selecionado.");
          yield InitialOrderBlocState(completeOrder: orderService.completeOrder);
        } else {
          CompleteOrder completeOrder = await orderService.add(order: orderService.order);
          if(completeOrder.Message == null){
            orderService.completeOrder = CompleteOrder(discount: 0);
            orderService.order = Order();
            yield OrderMade();
            yield InitialOrderBlocState();
          } else {
            yield OrderNotMade(msg: completeOrder.Message);
          }
        }
      } catch(e, s){
        print("Exception: $e\n");
        print("Stack: $s\n");
        yield OrderNotMade();
      }
    }

    if(event is RemoveProduct){
      orderService.completeOrder.products.removeAt(event.productIndex);
      orderService.order.products.removeAt(event.productIndex);
      orderService.completeOrder.value = orderService.calculateValue();
      orderService.completeOrder.totalValue = orderService.calculateTotalValue();
      yield LoadingOrders();
      yield OrderUpdated(completeOrder: orderService.completeOrder);
    }

    if(event is LoadOrders){
      yield LoadingOrders();
      List<CompleteOrder> completeOrders = await orderService.get();
      if(completeOrders.length != 0)
        yield OrdersLoaded(orders: completeOrders);
      else
        yield OrdersNotLoaded(msg: "Não há pedidos ou ocorreu um erro no servidor!");
    }

    if(event is FilterOrders){
      yield LoadingOrders();
      yield OrdersFiltered(orders: filterOrders(event.orders, event.filter));
    }
  }

  List<CompleteOrder> filterOrders(List<CompleteOrder> orders, String filter){
    return orders.where((order) =>
        order.client.name.toLowerCase().contains(filter.toLowerCase()) ||
        order.client.email.toLowerCase().contains(filter.toLowerCase()) ||
        order.date.toString().toLowerCase().contains(filter.toLowerCase())
        ||
        order.products.where((product) =>
            product.product.desc.toLowerCase().contains(filter.toLowerCase())
        ).toList().length > 0
    ).toList();
  }
}

abstract class OrderBlocEvent{}

class LoadOrders extends OrderBlocEvent{}

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

class RemoveProduct extends OrderBlocEvent{
  final int productIndex;
  RemoveProduct({this.productIndex});
}

class FilterOrders extends OrderBlocEvent{
  final String filter;
  final List<CompleteOrder> orders;
  FilterOrders({this.filter, this.orders});
}

abstract class OrderBlocState{}

class OrderUpdated extends OrderBlocState{
  final CompleteOrder completeOrder;
  OrderUpdated({this.completeOrder});
}

class UpdatingOrder extends OrderBlocState{}

class InitialOrderBlocState extends OrderBlocState{
  final CompleteOrder completeOrder;
  InitialOrderBlocState({this.completeOrder});
}

class MakingOrder extends OrderBlocState{}

class OrderMade extends OrderBlocState{}

class OrderNotMade extends OrderBlocState{
  final String msg;
  OrderNotMade({this.msg});
}

class SelectingAmount extends OrderBlocState{
  final CompleteOrder completeOrder;
  SelectingAmount({this.completeOrder});
}

class OrdersLoaded extends OrderBlocState{
  final List<CompleteOrder> orders;
  OrdersLoaded({this.orders});
}

class OrdersFiltered extends OrderBlocState{
  final List<CompleteOrder> orders;
  OrdersFiltered({this.orders});
}

class OrdersNotLoaded extends OrderBlocState{
  final String msg;
  OrdersNotLoaded({this.msg});
}

class LoadingOrders extends OrderBlocState{}