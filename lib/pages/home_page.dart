import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction_service.dart';
import '../models/transaction.dart';
import 'transaction_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  final transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() { isLoading = true; });
    try {
      final data = await transactionService.fetchAll();
      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ambil data: $e')),
      );
    }
  }

  Future<void> deleteTransaction(int id) async {
    await transactionService.delete(id);
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Income & Expense)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Income Section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.download, color: Colors.green),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pemasukan",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                formatter.format(
                                  transactions.where((t) => t.type == 1).fold(0.0, (a, b) => a + b.amount)
                                ),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Expense Section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.upload, color: Colors.red),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pengeluaran",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                formatter.format(
                                  transactions.where((t) => t.type == 2).fold(0.0, (a, b) => a + b.amount)
                                ),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Transaction",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? const Center(child: Text("Belum ada transaksi"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final trx = transactions[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await deleteTransaction(trx.id);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => TransactionPage(transaction: trx)),
                                          );
                                          if (result == true) {
                                            fetchTransactions();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  title: Text(formatter.format(trx.amount)),
                                  subtitle: Text(trx.name),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      trx.type == 2 ? Icons.upload : Icons.download,
                                      color: trx.type == 2 ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}