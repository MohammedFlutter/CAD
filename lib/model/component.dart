import 'package:cad/model/branch.dart';

class Component {
  String? id;
  String name;

  int negativeNode;
  int positiveNode;

  ComponentType type;
  double value;

  Component(
      {this.id,
      required this.name,
      required this.positiveNode,
      required this.negativeNode,
      required this.type,
      required this.value});

  Branch toBranch() {
    double? voltage, resistance, current;

    switch (type) {
      case ComponentType.voltageSource:
        voltage = value;
      case ComponentType.resistance:
        resistance = value;
      case ComponentType.currentSource:
        current = value;
    }
    return Branch(
        id: id,
        name: name,
        negativeNode: negativeNode,
        positiveNode: positiveNode,
        currentSource: current,
        resistance: resistance,
        voltageSource: voltage);
  }
}

enum ComponentType {
  resistance,
  voltageSource,
  currentSource,
}
