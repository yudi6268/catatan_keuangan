import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  final _client = Supabase.instance.client;

  Future<List<Transaction>> fetchAll() async {
    final data = await _client.from('transaction').select();
    return (data as List).map((e) => Transaction.fromMap(e)).toList();
  }
  
 Future<void> insert({
  required String name,
  required int categoryId,
  required String transactionCode,
  required double amount,
  required int type, // <-- tambahkan type
}) async {
  final now = DateTime.now().toIso8601String();
  await _client.from('transaction').insert({
    'name': name,
    'category_id': categoryId,
    'amount': amount,
    'type': type, // <-- tambahkan type
    'created_at': now,
    'updated_at': now,
  });
}

  Future<void> update({
  required int id,
  required String name,
  required int categoryId,
  required String transactionCode,
  required double amount,
  required int type, // <-- harus ada
}) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('transaction').update({
      'name': name,
      'category_id': categoryId,
      'amount': amount,
      'updated_at': now,
    }).eq('id', id);
  }

 Future<void> delete(int id) async {
  await _client.from('transaction').delete().eq('id', id);
}
  }
