import 'package:supabase_flutter/supabase_flutter.dart';

class Category {
    final String id;
    final String name;
    final String type;
    final DateTime createdAt;
    final DateTime updatedAt;
    final DateTime? deletedAt;

    Category({
        required this.id,
        required this.name,
        required this.type,
        required this.createdAt,
        required this.updatedAt,
        this.deletedAt,
    });

    factory Category.fromMap(Map<String, dynamic> map) {
        return Category(
            id: map['id'] as String,
            name: map['name'] as String,
            type: map['type'] as String,
            createdAt: DateTime.parse(map['createdAt'] as String),
            updatedAt: DateTime.parse(map['updatedAt'] as String),
            deletedAt: map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'name': name,
            'type': type,
            'createdAt': createdAt.toIso8601String(),
            'updatedAt': updatedAt.toIso8601String(),
            'deletedAt': deletedAt?.toIso8601String(),
        };
    }
}

class CategoryService {
    final SupabaseClient _client = Supabase.instance.client;
    final String _table = 'category';

    Future<List<Category>> getAll() async {
        final response = await _client.from(_table).select().eq('deletedAt', Null).order('createdAt');
        return (response as List).map((e) => Category.fromMap(e)).toList();
    }

    Future<Category?> getById(String id) async {
        final response = await _client.from(_table).select().eq('id', id).single();
        if (response == Null) return null;
        return Category.fromMap(response);
    }

    Future<Category> create(String name, String type) async {
        final now = DateTime.now();
        final data = {
            'name': name,
            'type': type,
            'createdAt': now.toIso8601String(),
            'updatedAt': now.toIso8601String(),
            'deletedAt': null,
        };
        final response = await _client.from(_table).insert(data).select().single();
        return Category.fromMap(response);
    }

    Future<Category?> update(String id, {String? name, String? type}) async {
        final now = DateTime.now();
        final data = <String, dynamic>{
            'updatedAt': now.toIso8601String(),
        };
        if (name != null) data['name'] = name;
        if (type != null) data['type'] = type;

        final response = await _client.from(_table).update(data).eq('id', id).select().single();
        if (response == Null) return null;
        return Category.fromMap(response);
    }

    Future<void> delete(String id) async {
        final now = DateTime.now();
        await _client.from(_table).update({'deletedAt': now.toIso8601String(), 'updatedAt': now.toIso8601String()}).eq('id', id);
    }
}