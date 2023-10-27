
class Branch {
  String? id;
  String name;

  int negativeNode;
  int positiveNode;

  double? currentSource;
  double? voltageSource;
  double? resistance;

  double? voltage;
  double? current;


  Branch(
      {this.id,
      required this.name,
      required this.negativeNode,
      required this.positiveNode,
      this.currentSource,
      this.voltageSource,
      this.resistance});
}
