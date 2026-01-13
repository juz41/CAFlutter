import 'package:flutter/material.dart';

class StateDefinition {
  String name;
  Color color;

  StateDefinition({required this.name, required this.color});
  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.toARGB32(),
      };

  factory StateDefinition.fromJson(Map<String, dynamic> json) {
    return StateDefinition(
      name: json['name'],
      color: Color(json['color']),
    );
  }
}
