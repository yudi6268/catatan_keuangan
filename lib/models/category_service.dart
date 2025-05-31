import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart'; // Tambahkan ini

class CategoryService {
  final _client = Supabase.instance.client;

  Future<List<Category>> getAllCategoryRepo(int type) async {
    final data = await _client
        .from('category')
        .select()
        .eq('type', type)
        .filter('deleted_at', 'is', null);
    return (data as List).map((e) => Category.fromMap(e as Map<String, dynamic>)).toList();
  }
}