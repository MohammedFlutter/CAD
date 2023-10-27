
import 'package:cad/provider/tree_and_cotree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrices/matrices.dart';
main(){

  group('tree ', () {
    final treeAndCotree = TreeAndCotree();

    test('cut column', () {
      var mat = Matrix.fromList([[1,2],[3,4]]);
      var match =Matrix.fromList([[1],[3]]) ;

      expect(equal(treeAndCotree.cutMatrix([0], mat), match), true);
    });

    // test();


  });
}

bool equal (Matrix matrixA ,Matrix matrixB){
  if(!(matrixA.rowCount==matrixB.rowCount&&matrixA.columnCount==matrixB.columnCount)){
    return false;
  }
  for(int i= 0 ;i<matrixA.rowCount ;i++){
    for(int j= 0 ;j<matrixA.columnCount ;j++){
      if(matrixA[i][j]!=matrixB[i][j]){
        return false;
      }
    }
  }
  return true;

}