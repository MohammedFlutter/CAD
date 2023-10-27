import 'package:cad/provider/result_provider.dart';
import 'package:cad/ui/widget/branch_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: !Provider.of<ResultProvider>(context).canAnalysis()
              ? const Center(
                  child: Text(
                    "Tree can't create",
                    style: TextStyle(color: Colors.green, fontSize: 32),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<ResultProvider>(context).branches().length,
                  itemBuilder: (_, index) => BranchCard(
                      branch: Provider.of<ResultProvider>(context)
                          .branches()[index]),
                )),
    );
  }
}
