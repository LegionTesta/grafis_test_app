// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map json) {
  return Product(
    id: json['id'] as int,
    desc: json['desc'] as String,
    price: (json['price'] as num)?.toDouble(),
    Message: json['Message'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('desc', instance.desc);
  writeNotNull('price', instance.price);
  writeNotNull('Message', instance.Message);
  return val;
}
