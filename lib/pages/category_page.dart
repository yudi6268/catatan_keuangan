// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category_service.dart';
import '../models/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _refreshKey = 0;
  bool isExpense = true; // true: expense, false: income
  int get type => isExpense ? 2 : 1;
  final categoryService = CategoryService();
  final TextEditingController categoryNameController = TextEditingController();

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  Future<void> _insertCategory() async {
    if (categoryNameController.text.trim().isEmpty) return;
    await categoryService.insert(categoryNameController.text.trim(), type);
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _updateCategory(int id) async {
    if (categoryNameController.text.trim().isEmpty) return;
    await categoryService.update(id, categoryNameController.text.trim());
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _deleteCategory(int id) async {
    await categoryService.delete(id);
    setState(() {
      _refreshKey++;
    });
  }

  void _showAddDialog() {
    categoryNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isExpense ? "Tambah Pengeluaran" : "Tambah Pemasukan",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
        content: TextField(
          controller: categoryNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Nama Kategori",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _insertCategory();
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Category cat) {
    categoryNameController.text = cat.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Kategori",
          style: GoogleFonts.montserrat(fontSize: 18),
        ),
        content: TextField(
          controller: categoryNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Nama Kategori",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateCategory(cat.id);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: isExpense,
                      onChanged: (val) {
                      setState(() {
                        isExpense = val;
                        _refreshKey++;
                      });
                    },
                      activeColor: Colors.red,
                      inactiveThumbColor: Colors.green,
                      inactiveTrackColor: Colors.green[200],
                    ),
                    Text(
                      isExpense ? "Pengeluaran" : "Pemasukan",
                      style: GoogleFonts.montserrat(
                        color: isExpense ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              key: ValueKey(_refreshKey),
              future: categoryService.getAllCategory(type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final cat = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(
                              cat.type == 2 ? Icons.upload : Icons.download,
                              color: cat.type == 2 ? Colors.redAccent : Colors.green,
                            ),
                            title: Text(
                              cat.name,
                              style: GoogleFonts.montserrat(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditDialog(cat),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteCategory(cat.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data"));
                } else {
                  return const Center(child: Text("Gagal memuat data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}