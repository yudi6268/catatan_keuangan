import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  final _client = Supabase.instance.client;

  Future<List<Transaction>> fetchAll() async {
    final data = await _client.from('transaction').select().filter('deleted_at', 'is', null);
    return (data as List).map((e) => Transaction.fromMap(e)).toList();
  }

  Future<void> insert({
    required String name,
    required int categoryId,
    required String transactionCode,
    required double amount,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('transaction').insert({
      'name': name,
      'category_id': categoryId,
      'transaction_code': transactionCode,
      'amount': amount,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });
  }

  Future<void> update({
    required int id,
    required String name,
    required int categoryId,
    required String transactionCode,
    required double amount,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('transaction').update({
      'name': name,
      'category_id': categoryId,
      'transaction_code': transactionCode,
      'amount': amount,
      'updated_at': now,
    }).eq('id', id);
  }

  Future<void> delete(int id) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('transaction').update({
      'deleted_at': now,
      'updated_at': now,
    }).eq('id', id);
  }
}