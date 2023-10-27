import 'package:cad/model/branch.dart';
import 'package:cad/provider/three_matrix_provider.dart';
import 'package:matrices/matrices.dart';

class ResultProvider {
  //todo: know order of branch

  final ThreeMatrixProvider matrixProvider;

  ResultProvider({required this.matrixProvider});

  bool canAnalysis()=> matrixProvider.branchesColumnNumber.isNotEmpty;

  SquareMatrix ZB() => SquareMatrix.diagonal(matrixProvider.branchesColumnNumber
      .map((e) => matrixProvider.branches[e].resistance ?? 0)
      .toList());

  Matrix IB() => Matrix.fromFlattenedList(
      matrixProvider.branchesColumnNumber
          .map((e) => matrixProvider.branches[e].currentSource ?? 0)
          .toList(),
      matrixProvider.branchesColumnNumber.length,
      1);

  Matrix EB() => Matrix.fromFlattenedList(
      matrixProvider.branchesColumnNumber
          .map((e) => matrixProvider.branches[e].voltageSource ?? 0)
          .toList(),
      matrixProvider.branchesColumnNumber.length,
      1);

  Matrix IL() {
    var matrixB = matrixProvider.matrixB;
    var x = matrixB * EB() - matrixB * ZB() * IB();
    var y = matrixB * ZB() * matrixB.transpose;
    return SquareMatrix.fromList(y.matrix).inverse * x;
  }

  Matrix JB() {
    return matrixProvider.matrixB.transpose * IL();
  }

  Matrix VB() {
    var x = JB() + IB();
    return ZB() * x - EB();
  }

  List<Branch> branches() => matrixProvider.branchesColumnNumber
      .map((e) => matrixProvider.branches[e]
        ..voltage = VB()[e][0]
        ..current = JB()[e][0])
      .toList();
}
