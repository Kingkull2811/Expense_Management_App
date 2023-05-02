class Wallet {
  final int id;
  final int accountBalance;
  final String name;
  final String accountType;
  final String currency;
  final String description;
  final String createdAt;
  final int createdBy;
  final bool report;

  Wallet({
    required this.id,
    required this.accountBalance,
    required this.name,
    required this.accountType,
    required this.currency,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.report,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      accountBalance: json['accountBalance'],
      name: json['name'],
      accountType: json['accountType'],
      currency: json['currency'],
      description: json['description'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      report: json['report'],
    );
  }

  @override
  String toString() {
    return 'Wallet{id: $id, accountBalance: $accountBalance, name: $name, accountType: $accountType, currency: $currency, description: $description, createdAt: $createdAt, createdBy: $createdBy, report: $report}';
  }
}
