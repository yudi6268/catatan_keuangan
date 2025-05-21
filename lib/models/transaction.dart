import 'package:uuid/uuid.dart';

class Transaction {
  String id;
  String name;
  String categoryId;
  String transactionCode;
  double amount;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  Transaction({
    String? id,
    required this.name,
    required this.categoryId,
    required this.transactionCode,
    required this.amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Create from Map (e.g., from database)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      categoryId: map['categoryId'],
      transactionCode: map['transactionCode'],
      amount: map['amount'] is int ? (map['amount'] as int).toDouble() : map['amount'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      deletedAt: map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
    );
  }

  // Convert to Map (e.g., for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'transactionCode': transactionCode,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Update transaction
  void update({
    String? name,
    String? categoryId,
    String? transactionCode,
    double? amount,
  }) {
    if (name != null) this.name = name;
    if (categoryId != null) this.categoryId = categoryId;
    if (transactionCode != null) this.transactionCode = transactionCode;
    if (amount != null) this.amount = amount;
    updatedAt = DateTime.now();
  }

  // Soft delete
  void delete() {
    deletedAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Restore
  void restore() {
    deletedAt = null;
    updatedAt = DateTime.now();
  }
}