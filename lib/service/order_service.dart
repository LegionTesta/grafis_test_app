
import 'package:grafis_test_app/api/order_api.dart';
import 'package:grafis_test_app/core/order.dart';

class OrderService{

  OrderService._();

  static OrderService  _instance;

  static OrderService get instance{
    if(_instance == null){
      _instance = OrderService._();
    }
    return _instance;
  }

  OrderApi orderApi = OrderApi();

  Order order = Order();
  CompleteOrder completeOrder = CompleteOrder(discount: 0);

  double calculateValue(){
    double value = 0;
    completeOrder.products.forEach((element) {value += (element.product.price * element.amount);});
    return value;
  }

  double calculateTotalValue(){
    return completeOrder.value - completeOrder.discount;
  }

  Future<List<CompleteOrder>> get() async{
    List<Map<String, dynamic>> ordersJson = await orderApi.get();
    List<CompleteOrder> orders = List();
    ordersJson.forEach((element) => orders.add(CompleteOrder.fromJson(element)));
    return orders;
  }

  Future<CompleteOrder> add({Order order}) async{
    return CompleteOrder.fromJson(await orderApi.post(body: order.toJson()));
  }
}