class LimitData {
  final int id;
  final int amount;
  final int actualAmount;
  final String limitName;
  final List<String> categoryIds;
  final List<String> walletIds;
  final DateTime fromDate;
  final DateTime toDate;

  LimitData({
    required this.id,
    required this.amount,
    required this.actualAmount,
    required this.limitName,
    required this.categoryIds,
    required this.walletIds,
    required this.fromDate,
    required this.toDate,
  });

  factory LimitData.fromJson(Map<String, dynamic> json) {
    return LimitData(
      id: json['id'],
      amount: json['amount'],
      actualAmount: json['actualAmount'],
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
}
