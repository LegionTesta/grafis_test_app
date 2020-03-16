// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteOrder _$CompleteOrderFromJson(Map json) {
  return CompleteOrder(
    id: json['id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    products: (json['products'] as List)
        ?.map((e) => e == null
            ? null
            : CompleteOrderProduct.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    client: json['client'] == null
        ? null
        : Client.fromJson((json['client'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    value: (json['value'] as num)?.toDouble(),
    discount: (json['discount'] as num)?.toDouble(),
    totalValue: (json['totalValue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CompleteOrderToJson(CompleteOrder instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull(
      'products', instance.products?.map((e) => e?.toJson())?.toList());
  writeNotNull('client', instance.client?.toJson());
  writeNotNull('value', instance.value);
  writeNotNull('discount', instance.discount);
  writeNotNull('totalValue', instance.totalValue);
  return val;
}

CompleteOrderProduct _$CompleteOrderProductFromJson(Map json) {
  return CompleteOrderProduct(
    product: json['product'] == null
        ? null
        : Product.fromJson((json['product'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    amount: (json['amount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CompleteOrderProductToJson(
    CompleteOrderProduct instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('product', instance.product?.toJson());
  writeNotNull('amount', instance.amount);
  return val;
}

Order _$OrderFromJson(Map json) {
  return Order(
    products: (json['products'] as List)
        ?.map((e) => e == null
            ? null
            : OrderProduct.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    clientId: json['clientId'] as int,
    discount: (json['discount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'products', instance.products?.map((e) => e?.toJson())?.toList());
  writeNotNull('clientId', instance.clientId);
  writeNotNull('discount', instance.discount);
  return val;
}

OrderProduct _$OrderProductFromJson(Map json) {
  return OrderProduct(
    productId: json['productId'] as int,
    amount: (json['amount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('productId', instance.productId);
  writeNotNull('amount', instance.amount);
  return val;
}
