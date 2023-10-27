import 'package:cad/provider/tree_and_cotree.dart';
import 'package:cad/model/branch.dart';
import 'package:cad/model/component.dart';
import 'package:cad/provider/convert_components_to_branchs.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrices/matrices.dart';

class ThreeMatrixProvider {
  ThreeMatrixProvider({required List<Component> components})
      : treeAndCotree = TreeAndCotree(),
        branches = ComponentsToBranchesConverter(components).toBranches() {
    try {
      var x =
          treeAndCotree.getTreeAndCotreeColumnNumbers(completeMatrix(matrixA));
      // branchesColumnNumber.addAll(x.tree);

      if (x != null) {
        branchesColumnNumber.addAll(x.tree);
        branchesColumnNumber.addAll(x.cotree);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // branchesColumnNumber.addAll(x.cotree);
    // else {
    //   // throw Exception('cant separate');
    // }
    // print(x);
  }

  final List<Branch> branches;
  final TreeAndCotree treeAndCotree;
  List<int> branchesColumnNumber = [];

  Matrix get matrixA {
    return Matrix.fromList(_nodes
        .map((node) => branches.map((e) {
              if (node == e.positiveNode) {
                return -1.0;
              }
              if (node == e.negativeNode) {
                return 1.0;
              }
              return 0.0;
            }).toList())
        .toList())
      ..deleteRow(_nodes.length - 1);
  }

  List<int> get _nodes {
    Set<int> nodes = {};
    for (var element in branches) {
      nodes.add(element.positiveNode);
      nodes.add(element.negativeNode);
    }
    return nodes.toList()..sort();
  }

  ///this function try recover matrix
  ///it use Tree checker
  Matrix completeMatrix(Matrix matrix) {
    matrix.appendRows(Matrix.zero(1, matrix.columnCount));
    for (int i = 0; i < matrix.columnCount; i++) {
      var sumOfRow =
          matrix.column(i).reduce((value, element) => value + element);
      matrix[matrix.rowCount - 1][i] = switch (sumOfRow) {
        == 1 => -1,
        == -1 => 1,
        == 0 => 0,
        _ => throw Exception('invalid matrix')
      };
    }
    if (matrix[matrix.rowCount - 1].every((element) => element == 0)) {
      matrix.deleteRow(matrix.rowCount - 1);
    }
    return matrix;
  }

  /// At^-1 *Al
  Matrix get matrixCLink {
    // var treeAndCotreeColumn =
    //     treeAndCotree.getTreeAndCotreeColumnNumbers(completeMatrix(matrixA))!;
    // var (matrixATree, matrixALink) = (
    //   treeAndCotree.cutMatrix(treeAndCotreeColumn.tree, matrixA),
    //   treeAndCotree.cutMatrix(treeAndCotreeColumn.cotree, matrixA),
    // );
    var treeIndexes = branchesColumnNumber.sublist(0, matrixA.rowCount);
    var cotreeIndexes = branchesColumnNumber.sublist(matrixA.rowCount);
    var (matrixATree, matrixALink) = (
      treeAndCotree.cutMatrix(treeIndexes, matrixA),
      treeAndCotree.cutMatrix(cotreeIndexes, matrixA),
    );

    return SquareMatrix.fromList(matrixATree.matrix).inverse * matrixALink;
  }

  /// At^-1 *A
  Matrix get matrixC {
    var ctree = SquareMatrix.identity(matrixCLink.rowCount);

    return ctree..appendColumns(matrixCLink);
  }

  ///  Btree= - transpose (Clink )
  ///  Blink = unit matrix
  /// B = (Btree, Blink)
  Matrix get matrixB {
    var btree = matrixCLink.transpose * -1;
    var blink = SquareMatrix.identity(btree.rowCount);
    return btree..appendColumns(blink);
  }
}
