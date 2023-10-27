import 'package:cad/model/branch.dart';
import 'package:cad/model/component.dart';

class ComponentsToBranchesConverter {
  final List<Branch> branches = [];
  final List<Component> _vSources;
  final List<Component> _cSources;
  final List<Component> _resistances;

  ComponentsToBranchesConverter(List<Component> components)
      : _vSources = components
            .where((element) => element.type == ComponentType.voltageSource)
            .toList(),
        _cSources = components
            .where((element) => element.type == ComponentType.currentSource)
            .toList(),
        _resistances = components
            .where((element) => element.type == ComponentType.resistance)
            .toList();

  List<Branch> toBranches() {
    List<Branch> branches = [];

    //check for voltage sources
    for (var source in _vSources) {
      if (_resistances.any((resistance) => isParallel(resistance, source))) {
        branches.add(source.toBranch());
      } else {
        var connectAtPositive = _resistances.where(
            (resistance) => isSeries(source, resistance, source.positiveNode));
        var connectAtNegative = _resistances.where(
            (resistance) => isSeries(source, resistance, source.negativeNode));
        if (connectAtNegative.length == 1) {
          branches.add(combine(source, connectAtNegative.first));
          _resistances.remove(connectAtNegative.first);
        } else if (connectAtPositive.length == 1) {
          branches.add(combine(source, connectAtPositive.first));
          _resistances.remove(connectAtPositive.first);
        } else {
          branches.add(source.toBranch());
        }
      }
    }
    //check for current source
    for (var source in _cSources) {
      var availableResistances =
          _resistances.where((resistance) => isParallel(resistance, source));
      if (availableResistances.isEmpty) {
        branches.add(source.toBranch());
      } else {
        branches.add(combine(source, availableResistances.first));
        _resistances.remove(availableResistances.first);
      }
    }
    //remained resistances
    for (var resistance in _resistances) {
      branches.add(resistance.toBranch());
    }
    return branches;
  }

  Branch combine(Component source, Component resistance) {
    int? negativeNode, positiveNode;
    if (!isParallel(source, resistance)) {
      if (isSeries(source, resistance, source.negativeNode)) {
        positiveNode = source.positiveNode;
        negativeNode = (source.negativeNode == resistance.negativeNode)
            ? resistance.positiveNode
            : resistance.negativeNode;
      } else {
        negativeNode = source.negativeNode;
        positiveNode = (source.positiveNode == resistance.negativeNode)
            ? resistance.positiveNode
            : resistance.negativeNode;
      }
    }
    return source.toBranch()
      ..positiveNode = positiveNode ?? source.positiveNode
      ..negativeNode = negativeNode ?? source.negativeNode
      ..resistance = resistance.value
      ..name = ' ${resistance.name}';
  }

  bool isSeries(Component c1, Component c2, int at) =>
      ((at == c1.positiveNode || at == c1.negativeNode) &&
          (at == c2.positiveNode || at == c2.negativeNode));

  bool isParallel(
    Component c1,
    Component c2,
  ) =>
      {c1.negativeNode, c1.positiveNode, c2.negativeNode, c2.positiveNode}
          .length ==
      2;
}
