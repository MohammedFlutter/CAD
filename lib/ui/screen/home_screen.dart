// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cad/provider/components_provider.dart';
import 'package:cad/ui/screen/result_screen.dart';
import 'package:cad/ui/screen/set_component_screen.dart';
import 'package:cad/ui/widget/component_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Provider.of<ComponentsProvider>(context).components.isEmpty
                  ? const Center(child: Text('add some component'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: Provider.of<ComponentsProvider>(context)
                          .components
                          .length,
                      itemBuilder: (_, index) => Dismissible(
                        key: Key(index.toString()),
                        child: GestureDetector(
                          // onTap: () => onUpdate(context,index),
                          child: ComponentCard(
                              component:
                                  Provider.of<ComponentsProvider>(context)
                                      .components[index]),
                        ),
                        onDismissed: (direction) => onDelete(context, index),
                      ),
                    ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: Provider.of<ComponentsProvider>(context)
                                .components
                                .isEmpty
                            ? null
                            : () => analysis(context),
                        child: const Text('analysis')),
                  ),
                  IconButton(
                    onPressed: () => onAdd(context),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    tooltip: 'add component',
                  )
                ],
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () => onAdd(context),
        //     child: const Icon(Icons.add)),
      ),
    );
  }

  // void onUpdate(BuildContext context,  componet){
  //   Navigator.push(context,MaterialPageRoute(builder: (_)=> SetComponentScreen(component:componet ,)));
  //
  // }
  void onAdd(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SetComponentScreen()));
  }

  void onDelete(BuildContext context, int index) {
    Provider.of<ComponentsProvider>(context, listen: false)
        .deleteComponent(index);
  }

  analysis(BuildContext context) {

    try{


      Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ResultScreen()));

    }catch(e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.ERROR,
      //   title: 'Error',
      //   // desc: errorMessage,
      //   btnOkText: 'Ok',
      // ).show();
    }
    // print(Provider.of<ComponentsProvider>(context, listen: false).matrixA);
    // print(Provider.of<ComponentsProvider>(context, listen: false).nodes);
  }
}
