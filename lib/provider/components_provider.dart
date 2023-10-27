import 'dart:math';
import 'package:cad/provider/three_matrix_provider.dart';
import 'package:cad/model/component.dart';
import 'package:flutter/material.dart';

class ComponentsProvider extends ChangeNotifier {
  List<Component> components = [];
  ThreeMatrixProvider? threeMatrix ;

  void setComponent(Component component) {
    if (component.id == null) {
      component.id = Random().nextInt(2000000).toString();
      components.add(component);
    } else {
      int index= components.indexWhere((element) => element.id==component.id);
      components[index]=component;
    }
    notifyListeners();
  }

  void deleteComponent(int index) {
    components.removeAt(index);
    notifyListeners();
  }

  // void analysis() {
  //   threeMatrix = ThreeMatrixProvider(components: components);
  // }

}
