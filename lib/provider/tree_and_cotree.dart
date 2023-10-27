import 'package:matrices/matrices.dart';
import 'package:trotter/trotter.dart';

class TreeAndCotree {
  /// try generate List of number of column that is contain tree
  /// anther list for co-tree
  ({List<int> tree, List<int> cotree})? getTreeAndCotreeColumnNumbers(
      Matrix matrix) {
    var columnIndexes = List.generate(matrix.columnCount, (index) => index);
    ({List<int> tree, List<int> cotree})? result;
    for (var columns in Combinations(matrix.rowCount - 1, columnIndexes)()) {
      if (isTree(matrix, columns)) {
        var complement =
            columnIndexes.where((index) => !columns.contains(index)).toList();

        result = (tree: columns, cotree: complement);
        break;
      }
    }
    // if(result)
    return result;
  }

  bool isTree(Matrix matrix, List<int> list) {
    var graph = cutMatrix(list,matrix);
    return _hasAllNodes(graph) && _isConnected(graph) && !_isLoop(graph);
  }

  bool _isConnected(Matrix matrix) {
    var temp = List.generate(matrix.rowCount, (index) => false);

    if (matrix.columnCount == 1) return false;
    matrix.column(0).indexed.forEach((e) => temp[e.$1] = e.$2 != 0);
    for (int i = 1; i < matrix.columnCount; i++) {
      if (matrix.column(i).indexed.any((e) => e.$2 != 0 && temp[e.$1])) {
        matrix
            .column(i)
            .indexed
            .forEach((e) => temp[e.$1] = (e.$2 != 0 || temp[e.$1]));
      } else {
        return false;
      }
    }
    return true;
  }

  bool _isLoop(Matrix matrix) {
    if (matrix.columnCount <= 1) {
      throw Exception('add some components');
    }
    //check any couple branch
    if (_isConnectedParallel(matrix)) {
      return true;
    }

    // branches must not connect in one point
    if (_isConnectedSeries(matrix)) return false;

    // cycle of branch ex :abc  => abca then check a-b,b-c ,c-a
    var permutations =
        Compounds(List.generate(matrix.columnCount, (index) => index))()
            .where((element) => element.length > 2)
            .toList();
    for (var branches in permutations) {
      branches.add(branches.first);
      for (int i = 0; i < branches.length - 1; i++) {
        if (branches[i] == 0 && branches[i + 1] == 2) {}
        if (!_isConnected(
            cutMatrix([branches[i], branches[i + 1]], matrix))) {
          break;
        }
        if (i == branches.length - 2) {
          return true;
        }
      }
    }

    return false;
  }



  bool _isConnectedParallel(Matrix matrix) {
    var combinations =
        Combinations(2, List.generate(matrix.columnCount, (index) => index))()
            .toList();
    for (var branches in combinations) {
      bool isCouple = (matrix.column(branches[0]).indexed.every((cell) =>
          (cell.$2 == 0.0)
              ? matrix[cell.$1][branches[1]] == 0
              : matrix[cell.$1][branches[1]] != 0));
      if (isCouple) return true;
    }
    return false;
  }

  /// if a connected b ,a  connected c  ,a connected d return true
  bool _isConnectedSeries(Matrix matrix) {
    var temp = List.generate(matrix.rowCount, (index) => 0);
    for (int i = 0; i < matrix.rowCount; i++) {
      var noConnections =
          matrix.row(i).where((element) => element != 0).toList().length;
      temp[i] = noConnections;
    }
    return temp.contains(matrix.columnCount);
  }

  bool _hasAllNodes(Matrix matrix) {
    var temp = List.generate(matrix.rowCount, (index) => false);
    for (int i = 0; i < matrix.columnCount; i++) {
      for (int j = 0; j < matrix.column(i).length; j++) {
        if (matrix[j][i] == 0) {
          continue;
        }
        temp[j] = true;
      }
    }
    return temp.every((element) => element);
  }

//
  Matrix cutMatrix(List<int> columnsIndex, Matrix matrix) => Matrix.fromList([
      for (int i in columnsIndex) matrix.column(i),
    ]).transpose;
}
