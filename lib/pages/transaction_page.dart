import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/category_service.dart';
import '../models/category.dart';
import '../models/transaction_service.dart';
import '../models/transaction.dart';

class TransactionPage extends StatefulWidget {
  final Transaction? transaction;
  const TransactionPage({super.key, this.transaction});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  List<Category> categories = [];
  Category? selectedCategory;
  TextEditingController dateController = TextEditingController();

  // Tambahkan deklarasi controller berikut:
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final categoryService = CategoryService();
  final transactionService = TransactionService();
  

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final data = await categoryService.getAllCategory(isExpense ? 2 : 1);
    setState(() {
      categories = data;
      if (categories.isNotEmpty) {
        selectedCategory = categories.first;
      } else {
        selectedCategory = null;
      }
    });
  }

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
                    value: isExpense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpense = value;
                      });
                      fetchCategories();
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  isExpense
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
                controller: amountController, // <-- tambahkan ini!
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
                child: DropdownButton<Category>(
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  hint: const Text("Pilih kategori"),
                  items: categories.map((cat) {
                    return DropdownMenuItem<Category>(
                      value: cat,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue;
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
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2099));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-y').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 25),
              Center(
                  child: ElevatedButton(
      onPressed: (
  amountController.text.isNotEmpty &&
  selectedCategory != null
)
    ? () async {
        try {
          if (widget.transaction != null) {
            // UPDATE
            await transactionService.update(
              id: widget.transaction!.id,
              name: selectedCategory?.name ?? 'Transaksi Baru',
              categoryId: selectedCategory!.id,
              transactionCode: '-',
              amount: double.tryParse(amountController.text) ?? 0.0,
              type: isExpense ? 2 : 1,
            );
          } else {
            // INSERT
            await transactionService.insert(
              name: selectedCategory?.name ?? 'Transaksi Baru',
              categoryId: selectedCategory!.id,
              transactionCode: '-',
              amount: double.tryParse(amountController.text) ?? 0.0,
              type: isExpense ? 2 : 1,
            );
          }
          Navigator.pop(context, true); // Penting: kirim true ke home_page
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal simpan: $e')),
          );
        }
      }
    : null,
  child: Text("Save"),
),
              )],
          ),
        ),
      ),
    );
  }
}