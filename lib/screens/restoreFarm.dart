import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RestoreFarmScreen extends StatefulWidget {
  const RestoreFarmScreen({Key? key}) : super(key: key);

  @override
  _RestoreFarmScreenState createState() => _RestoreFarmScreenState();
}

class _RestoreFarmScreenState extends State<RestoreFarmScreen> {
  List<Map<String, dynamic>> archivedFarms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchivedFarms();
  }

  Future<void> _loadArchivedFarms() async {
    setState(() => isLoading = true);
    // Fetch archived farms from the database helper
    archivedFarms = await DatabaseHelper().getArchivedFarms();
    setState(() => isLoading = false);
  }

  Future<void> _restoreFarm(int farmId) async {
    // Restore the farm along with its expenses if needed
    int result = await DatabaseHelper().restoreFarmWithExpenses(farmId);
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Farm restored successfully!")),
      );
      _loadArchivedFarms(); // Refresh the list after restoration
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to restore farm. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archived Farms"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : archivedFarms.isEmpty
          ? Center(child: Text("No archived farms available"))
          : ListView.builder(
        itemCount: archivedFarms.length,
        itemBuilder: (context, index) {
          final farm = archivedFarms[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(farm['name'] ?? "Unnamed Farm"),
              subtitle: Text("Crop: ${farm['crop'] ?? "N/A"}"),
              trailing: IconButton(
                icon: Icon(Icons.restore, color: Colors.green),
                onPressed: () => _restoreFarm(farm['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
