import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  final _client = Supabase.instance.client;

  Future<List<Categories>> fetchAll() async {
    final data = await _client.from('category').select().filter('deleted_at', 'is', null);
    return (data as List).map((e) => Categories.fromMap(e)).toList();
  }

  Future<void> insert(String name, int type) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('category').insert({
      'name': name,
      'type': type,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });
  }

  // update, delete, etc...
}