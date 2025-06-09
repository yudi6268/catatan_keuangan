class Transaction {
  final int id;
  final String name;
  final double amount;
  final int type;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      name: map['name'] ?? '',
      amount: map['amount'] is int ? (map['amount'] as int).toDouble() : (map['amount'] ?? 0.0),
      type: map['type'] is int ? map['type'] : int.parse(map['type'].toString()),
    );
  }
}