// To parse this JSON data, do
//
//     final productomodel = productomodelFromJson(jsonString);

import 'dart:convert';

Productomodel productomodelFromJson(String str) =>
    Productomodel.fromJson(json.decode(str));

String productomodelToJson(Productomodel data) => json.encode(data.toJson());

class Productomodel {
  Productomodel({
    this.id,
    this.titulo,
    this.valor,
    this.disponible,
    this.fotoUrl,
  });

  String id;
  String titulo = '';
  double valor = 0.0;
  bool disponible = true;
  String fotoUrl;

  factory Productomodel.fromJson(Map<String, dynamic> json) => Productomodel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor "],
        disponible: json["disponible"],
        fotoUrl: json["foto_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "valor ": valor,
        "disponible": disponible,
        "foto_url": fotoUrl,
      };
}
