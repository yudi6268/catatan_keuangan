import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpanded = true;

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
                decoration: InputDecoration(border: 
                OutlineInputBorder(), hintText: "Name"),
              ),
              ElevatedButton(onPressed: () {}, child: Text("Save")),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 10,
          child: ListTile(
            leading: isExpanded ? Icon(Icons.upload, color: Colors.red) : Icon(Icons.download, color: Colors.green),
            title: Text("Amal"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              SizedBox(width: 10,),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ],),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 10,
          child: ListTile(
            leading: isExpanded ? Icon(Icons.upload, color: Colors.red) : Icon(Icons.download, color: Colors.green),
            title: Text("Makan"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              SizedBox(width: 10,),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ],),
          ),
        ),
      )

    ],));
  }
}