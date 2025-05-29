import 'package:duitku/models/category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_service.dart';


class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpanded = true;
  final SupabaseClient client = Supabase.instance.client;
  final categoryService = CategoryService();
  TextEditingController categorynameController = TextEditingController();
  
  Future insert(String name, int type) async {
  final now = DateTime.now().toIso8601String();
  final response = await client.from('categories').insert({
    'name': name,
    'type': type,
    'created_at': now,
    'updated_at': now,
    'deleted_at': null,
  });
  print(response); // atau print(response.error) jika ingin cek error
}

Future<List<Categories>> getAllCategory(int type) async {
  return await categoryService.getAllCategoryRepo(type);
}

  void openDialog() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                (isExpanded) ? "Add Expense" : "Add Income", style: GoogleFonts.montserrat(fontSize: 18,
                color: (isExpanded) ? Colors.red : Colors.green),),
              SizedBox(height: 10,),
               TextFormField(
                controller: categorynameController,
                decoration: InputDecoration(border: 
                OutlineInputBorder(), hintText: "Name"),
              ),
              ElevatedButton(onPressed: () {
                insert(categorynameController.text, isExpanded ? 2 : 1);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                setState(() {
                  
                });
              }, child: Text("Save")),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Switch(value: isExpanded, onChanged: (bool value) {
            setState(() {
              isExpanded = value;
            });
          }, 
          inactiveTrackColor: Colors.green[200],
          inactiveThumbColor: Colors.green,
          activeColor: Colors.red,),
          IconButton(onPressed: () {
            openDialog();
          }, icon: Icon(Icons.add))
        
        ],),
      ),
           
    ],));
  }
}