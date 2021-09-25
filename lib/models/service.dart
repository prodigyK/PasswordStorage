import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String deliveryAddress;
  final String deliveryPort;
  final String sendAddress;
  final String sendPort;
  final bool ssl;
  final DateTime modifiedAt;

  Service({
    this.id,
    @required this.name,
    this.deliveryAddress,
    this.deliveryPort,
    this.sendAddress,
    this.sendPort,
    this.ssl,
    this.modifiedAt,
  });

  factory Service.empty() {
    return Service(
      id: null,
      name: null,
      deliveryAddress: null,
      deliveryPort: null,
      sendAddress: null,
      sendPort: null,
      ssl: null,
      modifiedAt: DateTime.now(),
    );
  }

  factory Service.fromJson(Map<String, dynamic> json, {String docID}) {
    return Service(
      id: docID != null ? docID : json['id'],
      name: json['name'],
      deliveryAddress: json['deliveryAddress'],
      deliveryPort: json['deliveryPort'],
      sendAddress: json['sendAddress'],
      sendPort: json['sendPort'],
      ssl: json['ssl'],
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': this.id,
      'name': this.name,
      'deliveryAddress': this.deliveryAddress,
      'deliveryPort': this.deliveryPort,
      'sendAddress': this.sendAddress,
      'sendPort': this.sendPort,
      'ssl': this.ssl,
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Service{id: $id, name: $name, deliveryAddress: $deliveryAddress, deliveryPort: $deliveryPort, sendAddress: $sendAddress, sendPort: $sendPort, ssl: $ssl, modifiedAt: $modifiedAt}';
  }
}
