import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../generated/l10n.dart';
import 'AddEditExpenseScreen.dart';
import 'ExpenseDetailScreen.dart'; // <-- Import this

class ExpenseListScreen extends StatefulWidget {
  final int farmId;

  ExpenseListScreen({required this.farmId});

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Map<String, dynamic>> expenses = [];
  Map<String, dynamic>? farmDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmDetails();
  }

  Future<void> _loadFarmDetails() async {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> farmData = await DatabaseHelper().getFarmById(widget.farmId);
    if (farmData.isNotEmpty) {
      farmDetails = farmData.first;
    }

    List<Map<String, dynamic>> expenseList = await DatabaseHelper().getExpensesByFarm(widget.farmId);

    setState(() {
      expenses = expenseList;
      isLoading = false;
    });

    debugPrint("✅ Loaded ${expenses.length} expenses for Farm ID: ${widget.farmId}");
    debugPrint("📄 Expenses Data: $expenses");
  }

  void _navigateToAddExpense() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(farmId: widget.farmId),
      ),
    );

    if (result == true) {
      debugPrint("🔄 Refreshing expenses after adding new record...");
      _loadFarmDetails();
      _showSnackBar("Expense added successfully!");
    }
  }

  void _navigateToEditExpense(Map<String, dynamic> expense) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(
          farmId: widget.farmId,
          expenseData: expense,
        ),
      ),
    );

    if (result == true) {
      _loadFarmDetails();
      _showSnackBar(S.of(context)!.expenseUpdatedSuccess);
    }
  }

  Future<void> _confirmArchiveExpense(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.archiveExpense),
        content: Text(S.of(context)!.expenseUpdatedSuccess),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(S.of(context)!.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(S.of(context)!.archive)),
        ],
      ),
    );

    if (confirm == true) _archiveExpense(id);
  }

  void _archiveExpense(int id) async {
    int result = await DatabaseHelper().archiveExpense(id);
    if (result > 0) {
      _loadFarmDetails();
      _showSnackBar(S.of(context)!.expenseArchivedSuccess);
    } else {
      _showSnackBar(S.of(context)!.expenseArchiveFailed);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.dayWiseExpenses)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (farmDetails != null) _buildFarmDetailsCard(),
          Expanded(
            child: expenses.isEmpty
                ? Center(child: Text(S.of(context)!.noFarmsFound))
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                String? imagePath = expense['image_path'];
                bool hasImage = imagePath != null &&
                    imagePath.isNotEmpty &&
                    File(imagePath).existsSync();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseDetailScreen(expense: expense),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hasImage
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.image, color: Colors.grey[700]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${expense['category']} - ₹${expense['amount']}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Wrap(
                                  children: [
                                    Text(
                                      "${expense['notes']}",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${expense['date']}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _navigateToEditExpense(expense),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmArchiveExpense(expense['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFarmDetailsCard() {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.teal[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              farmDetails!['name'] ?? S.of(context)!.unknownFarm,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[900]),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.agriculture, color: Colors.teal),
                SizedBox(width: 5),
                Text("Crop: ${farmDetails!['crop'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.landscape, color: Colors.teal),
                SizedBox(width: 5),
                Text("Area: ${farmDetails!['area']} ${farmDetails!['area_unit']}", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
