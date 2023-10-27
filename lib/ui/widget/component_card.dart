import 'package:cad/model/component.dart';
import 'package:cad/ui/screen/set_component_screen.dart';
import 'package:flutter/material.dart';

class ComponentCard extends StatelessWidget {
  final Component component;

  const ComponentCard({super.key, required this.component});

  final TextStyle _textStyle = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title:
            Text('${component.name} = ${component.value}', style: _textStyle),
        onTap: () => onUpdate(context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'negative node :  ${component.negativeNode}',
              style: _textStyle,
            ),
            Text(
              'positive node :  ${component.positiveNode}',
              style: _textStyle,
            ),
          ],
        ),
        // tileColor: Colors.amberAccent ,
        // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void onUpdate(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SetComponentScreen(
                  component: component,
                )));
  }
}
