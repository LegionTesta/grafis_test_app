
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

/*
 Um CompleteOrder, diferente da classe Order, é um pedido completo contendo
 todas as informações sobre o pedido, serve tanto para informar ao cliente na
 UI o valor total da compra, como para receber da api a lista de pedidos.
 */
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
  String Message;

  CompleteOrder({this.id, this.date, this.products, this.client, this.value,
    this.discount, this.totalValue, this.currentProduct, this.Message});

  factory CompleteOrder.fromJson(Map<String, dynamic> json) => _$CompleteOrderFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderToJson(this);
}

/*
  Um CompleteOrderProduct é o objeto utilizado na lista de produtos de um pedido
  completo. Diferente do OrderProduct, esta classe contém todas as inforamções
  de um produto.
 */
@JsonSerializable()
class CompleteOrderProduct{

  Product product;
  double amount;
  String Message;

  CompleteOrderProduct({this.product, this.amount, this.Message});

  factory CompleteOrderProduct.fromJson(Map<String, dynamic> json) => _$CompleteOrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderProductToJson(this);
}

/*
  Classe utilizada para cadastrar um pedido no banco de dados. Contem somente as
  informações necessárias para realizar um cadastro de pedido.
 */
@JsonSerializable()
class Order{

  List<OrderProduct> products;
  int clientId;
  double discount;
  String Message;

  Order({this.products, this.clientId, this.discount, this.Message});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

/*
  Classe utilizada na lista de produtos de um Order. Contem somente as informações
  necessárias para realizar um cadastro de pedido.
 */
@JsonSerializable()
class OrderProduct{

  int productId;
  double amount;
  String Message;

  OrderProduct({this.productId, this.amount, this.Message});

  factory OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}