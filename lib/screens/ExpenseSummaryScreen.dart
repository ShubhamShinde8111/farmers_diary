import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  @override
  _ExpenseSummaryScreenState createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;
  String selectedFilter = "All"; // Default: Show all expenses

  @override
  void initState() {
    super.initState();
    _loadExpenseSummary();
  }

  Future<void> _loadExpenseSummary({String? filter}) async {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> summaryData;
    if (filter == "Day") {
      summaryData = await DatabaseHelper().getDayWiseExpenses();
    } else if (filter == "Month") {
      summaryData = await DatabaseHelper().getMonthWiseExpenses();
    } else if (filter == "Year") {
      summaryData = await DatabaseHelper().getYearWiseExpenses();
    } else {
      summaryData = await DatabaseHelper().getExpenseSummary();
    }

    setState(() {
      expenses = summaryData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Summary"),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
              _loadExpenseSummary(filter: value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "All", child: Text("All Expenses")),
              PopupMenuItem(value: "Day", child: Text("Day Wise")),
              PopupMenuItem(value: "Month", child: Text("Month Wise")),
              PopupMenuItem(value: "Year", child: Text("Year Wise")),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          var expense = expenses[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text("Farm: ${expense['farm_name']}"),
              subtitle: Text("Total: ₹${expense['total']}"),
            ),
          );
        },
      ),
    );
  }
}