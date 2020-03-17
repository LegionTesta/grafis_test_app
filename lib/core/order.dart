
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class CompleteOrder{

  int id;
  DateTime date;
  List<CompleteOrderProduct> products;
  Client client;
  double value;
  double discount;
  double totalValue;
  Product currentProduct;
  String message;

  CompleteOrder({this.id, this.date, this.products, this.client, this.value,
    this.discount, this.totalValue, this.currentProduct, this.message});

  factory CompleteOrder.fromJson(Map<String, dynamic> json) => _$CompleteOrderFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderToJson(this);
}

@JsonSerializable()
class CompleteOrderProduct{

  Product product;
  double amount;
  String message;

  CompleteOrderProduct({this.product, this.amount, this.message});

  factory CompleteOrderProduct.fromJson(Map<String, dynamic> json) => _$CompleteOrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderProductToJson(this);
}

@JsonSerializable()
class Order{

  List<OrderProduct> products;
  int clientId;
  double discount;
  String message;

  Order({this.products, this.clientId, this.discount, this.message});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderProduct{

  int productId;
  double amount;
  String message;

  OrderProduct({this.productId, this.amount, this.message});

  factory OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}