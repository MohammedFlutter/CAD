import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.name, this.keyboardType= TextInputType.name, this.initialValue});
  final String name ;
  final TextInputType? keyboardType ;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      validator: (keyboardType==TextInputType.number )?FormBuilderValidators.compose([FormBuilderValidators.required(),FormBuilderValidators.numeric()]): FormBuilderValidators.required(),
      name: name,
      initialValue: initialValue,
      keyboardType:keyboardType,
      decoration:  InputDecoration(
          labelText: name,
          border: const OutlineInputBorder()),
    );
  }
}
