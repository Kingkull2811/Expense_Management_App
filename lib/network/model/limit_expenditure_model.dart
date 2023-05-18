class LimitModel {
  final int? id;
  final double? amount;
  final double? actualAmount;
  final String? limitName;
  final List<String>? categoryIds;
  final List<String>? walletIds;
  final DateTime? fromDate;
  final DateTime? toDate;

  LimitModel({
    this.id,
    this.amount,
    this.actualAmount,
    this.limitName,
    this.categoryIds,
    this.walletIds,
    this.fromDate,
    this.toDate,
  });

  factory LimitModel.fromJson(Map<String, dynamic> json) {
    return LimitModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      actualAmount: double.parse(json['actualAmount'].toString()),
      limitName: json['limitName'],
      categoryIds: List<String>.from(json['categoryIds']),
      walletIds: List<String>.from(json['walletIds']),
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'actualAmount': actualAmount,
        'limitName': limitName,
        'categoryIds': categoryIds,
        'walletIds': walletIds,
        'fromDate': fromDate,
        'toDate': toDate,
      };

  @override
  String toString() {
    return 'LimitModel{id: $id, amount: $amount, actualAmount: $actualAmount, limitName: $limitName, categoryIds: $categoryIds, walletIds: $walletIds, fromDate: $fromDate, toDate: $toDate}';
  }
}
