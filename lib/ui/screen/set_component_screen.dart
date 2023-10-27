import 'package:cad/model/component.dart';
import 'package:cad/provider/components_provider.dart';
import 'package:cad/ui/widget/costom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class SetComponentScreen extends StatefulWidget {
  final Component? component;

  const SetComponentScreen({super.key, this.component});

  @override
  State<SetComponentScreen> createState() => _SetComponentScreenState();
}

class _SetComponentScreenState extends State<SetComponentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  //
  var formKey = GlobalKey<FormBuilderState>();

  Widget buildForm() {
    return FormBuilder(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 160,
                  child: buildDropdownComponentType(),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: CustomTextField(
                  name: 'name',
                  initialValue: widget.component?.name,
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                    width: 160,
                    child: CustomTextField(
                      name: 'negative node',
                      keyboardType: TextInputType.number,
                      initialValue: widget.component?.negativeNode.toString(),
                    )),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                    width: 160,
                    child: CustomTextField(
                      name: 'positive node',
                      keyboardType: TextInputType.number,
                      initialValue: widget.component?.positiveNode.toString(),
                    ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              name: 'value',
              keyboardType: TextInputType.number,
              initialValue: widget.component?.value.toString(),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () => onSet(context), child: const Text('set'))
          ],
        ));
  }

  Widget buildDropdownComponentType() {
    return FormBuilderDropdown(
        decoration: const InputDecoration(
            labelText: 'type',
            hintText: 'select type',
            border: OutlineInputBorder()),
        name: 'type',
        initialValue: widget.component?.type,
        borderRadius: BorderRadius.circular(4),
        validator: FormBuilderValidators.required(),
        items: ComponentType.values
            .map((componentType) => DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                value: componentType,
                child: Text(componentType.name)))
            .toList());
  }

  void onSet(BuildContext context) {

// print('ssssssssssssssss'+ formKey.currentState?.fields['type']?.value);
    if (formKey.currentState?.validate() ?? false) {
      Provider.of<ComponentsProvider>(context, listen: false).setComponent(
          Component(
            id: widget.component?.id ,
              name: formKey.currentState?.fields['name']?.value,
              positiveNode: int.parse(
                  formKey.currentState?.fields['positive node']?.value),
              negativeNode: int.parse(
                  formKey.currentState?.fields['negative node']?.value),
              type: formKey.currentState?.fields['type']?.value,
              value: double.parse(
                  formKey.currentState?.fields['value']?.value))); //
      Navigator.pop(context);
    }
  }
}
