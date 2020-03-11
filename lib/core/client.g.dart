// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map json) {
  return Client(
    id: json['id'] as int,
    nome: json['nome'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$ClientToJson(Client instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('nome', instance.nome);
  writeNotNull('email', instance.email);
  return val;
}
