
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';
//TODO: product image
@JsonSerializable()
class Product{

  int id;
  String desc;
  double price;

  Product({this.id, this.desc, this.price});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}