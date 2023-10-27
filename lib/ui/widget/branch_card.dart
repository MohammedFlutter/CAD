import 'package:cad/model/branch.dart';
import 'package:flutter/material.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({super.key, required this.branch});

  final Branch branch;
  final  TextStyle _stye = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(branch.name ,style:  _stye,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('voltage ${branch.voltage}',style:  _stye,),
            Text('current ${branch.current}',style:  _stye,),
          ],
        ),
        // tileColor: Colors.amberAccent ,
        // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

  }
}
