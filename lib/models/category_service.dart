import 'package:supabase_flutter/supabase_flutter.dart';
import 'category.dart';

class CategoryService {
  final _client = Supabase.instance.client;

  Future<List<Category>> getAllCategory(int type) async {
    final data = await _client
        .from('category')
        .select()
        .eq('type', type)
        .filter('deleted_at', 'is', null)
        .order('name', ascending: true);
    return (data as List)
        .map((e) => Category.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insert(String name, int type) async {
  final now = DateTime.now().toIso8601String();
  try {
    final response = await _client.from('category').insert({
      'name': name,
      'type': type,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });
    print('Insert response: $response');
  } catch (e) {
    print('Insert error: $e');
  }
}

Future<void> delete(int id) async {
  try {
    final response = await _client.from('category').update({
      'deleted_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
    print('Delete response: $response');
  } catch (e) {
    print('Delete error: $e');
  }
}

Future<void> update(int id, String name) async {
  try {
    final response = await _client.from('category').update({
      'name': name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
    print('Update response: $response');
  } catch (e) {
    print('Update error: $e');
  }
}}