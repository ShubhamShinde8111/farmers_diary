import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RestoreExpenseScreen extends StatefulWidget {
  const RestoreExpenseScreen({Key? key}) : super(key: key);

  @override
  _RestoreExpenseScreenState createState() => _RestoreExpenseScreenState();
}

class _RestoreExpenseScreenState extends State<RestoreExpenseScreen> {
  List<Map<String, dynamic>> archivedExpenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchivedExpenses();
  }

  Future<void> _loadArchivedExpenses() async {
    setState(() => isLoading = true);
    try {
      final dbHelper = DatabaseHelper();
      archivedExpenses = await dbHelper.getArchivedExpensesWithFarmInfo();
    } catch (e) {
      debugPrint("❌ Error fetching archived expenses: $e");
    }
    setState(() => isLoading = false);
  }


  Future<void> _restoreExpense(int id) async {
    int result = await DatabaseHelper().restoreExpense(id);
    if (result > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Expense restored successfully!")));
      _loadArchivedExpenses();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to restore expense.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archived Expenses"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : archivedExpenses.isEmpty
          ? Center(child: Text("No archived expenses found."))
          : ListView.builder(
        itemCount: archivedExpenses.length,
        itemBuilder: (context, index) {
          final expense = archivedExpenses[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              title: Text("${expense['category']} - ₹${expense['amount']}"),
              subtitle: Text("Date: ${expense['date']}\nFarm: ${expense['farm_name']}"),
              trailing: IconButton(
                icon: Icon(Icons.restore, color: Colors.green),
                onPressed: () => _restoreExpense(expense['id']),
              ),
            ),
          );

        },
      ),
    );
  }
}