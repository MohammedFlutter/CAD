import 'package:cad/provider/components_provider.dart';
import 'package:cad/provider/result_provider.dart';
import 'package:cad/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cad/provider/three_matrix_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ComponentsProvider>(
          create: (_) => ComponentsProvider()),

      ProxyProvider<ComponentsProvider,ResultProvider>(update:(context, componentsProvider, previous) {
        return ResultProvider(matrixProvider: ThreeMatrixProvider(components: componentsProvider.components));
      }, ),
      // Provider<ResultProvider>(
      //   create: (context) => ResultProvider(
      //       matrixProvider: ThreeMatrixProvider(
      //           components:
      //               Provider.of<ComponentsProvider>(context,).components)),
      // ),
    ],
    child: const CADApp(),
  ));
}

class CADApp extends StatelessWidget {
  const CADApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
