import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpanded = true;
  List<String> list = ["Makan", "Transport", "Hiburan", "Belanja"];
  late String dropDownvalue = list.first;
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Switch for Expense/Income
              Row(
                children: [
                  Switch(
                    value: isExpanded,
                    onChanged: (bool value) {
                      setState(() {
                        isExpanded = value;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  isExpanded
                      ? Text("Pengeluaran",
                          style: GoogleFonts.montserrat(fontSize: 14))
                      : Text(
                          "Pemasukan",
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                ],
              ),
              SizedBox(height: 10),

              // Amount Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Jumlah",
                  ),
                ),
              ),

              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Category',
                    style: GoogleFonts.montserrat(fontSize: 16)),
              ),
              // Dropdown for Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: dropDownvalue,
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  readOnly: true,
                controller: dateController,
                decoration: InputDecoration(labelText: "Enter Date"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(context: context, 
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022), lastDate: DateTime(2099));
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('dd-MM-y').format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                }
                ),
              ),
              SizedBox(height: 25),
              Center(child: ElevatedButton(onPressed: () {}, child: Text("Save"))),
            ],
          ),
        ),
      ),
    );
  }
}