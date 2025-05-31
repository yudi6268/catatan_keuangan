import 'package:duitku/models/category.dart';
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
  int _refreshKey = 0;
  bool isExpanded = true;
  int type = 2; // 1 for Income, 2 for Expense
  final SupabaseClient client = Supabase.instance.client;
  final categoryService = CategoryService();
  TextEditingController categorynameController = TextEditingController();
  
  Future insert(String name, int type) async {
  final now = DateTime.now().toIso8601String();
  await client.from('category').insert({
    'name': name,
    'type': type,
    'created_at': now,
    'updated_at': now,
    'deleted_at': null,
  });
  setState(() {
    _refreshKey++; // Trigger FutureBuilder rebuild
  });
}

Future<List<Category>> getAllCategory(int type) async {
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
                setState(() {});
                  categorynameController.clear();
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
              type = value ? 2 : 1; // 2 for Expense, 1 for Income
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
      
 Expanded(
  child: FutureBuilder<List<Category>>(
    key: ValueKey(_refreshKey),
    future: getAllCategory(type),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator(),);
    } else if (snapshot.hasData) {
      if (snapshot.data!.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
          return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 10,
          child: ListTile(
              trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(icon: Icon(Icons.delete), onPressed: () {
              },),
              SizedBox(width: 10,),
              IconButton(icon: Icon(Icons.edit), onPressed: () {
              },)
            ],),
            leading: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
              child: (isExpanded!) ? Icon(Icons.upload,
              color: Colors.redAccent) : Icon(Icons.download, color: Colors.greenAccent)),
            title: Text(snapshot.data![index].name, style: GoogleFonts.montserrat(fontSize: 16),),
            )));
          },
        );
      } else {
        return Center(child: Text("No data"));
      }
    } else {
      return Center(child: Text("No data"));
    }
  }
 )),

],),
);
  }
}