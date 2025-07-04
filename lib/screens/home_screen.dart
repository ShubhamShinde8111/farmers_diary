import 'package:flutter/material.dart';
import 'package:newone/screens/download_data.dart';
import 'package:newone/screens/restoreFarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../generated/l10n.dart';
import 'ChangeLanguageScreen.dart';
import 'EditFarmScreen.dart';
import 'ExpenseListScreen.dart';
import 'Profile_Screen.dart';
import 'RestoreExpenseScreen.dart';
import 'TimelineScreen.dart';
import 'new_farm_screen.dart';
//import 'download_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  List<Map<String, dynamic>> farms = [];
  List<Map<String, dynamic>> filteredFarms = [];
  bool isLoading = true;
  bool _showFarmWiseExpenses = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    debugPrint("Fetching states...");
  }

  // Loads the user data and farms from SharedPreferences and the database.
  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> farmList = await DatabaseHelper().getAllFarms();

      setState(() {
        userName = prefs.getString('user_name') ?? "User";
        farms = farmList;
        filteredFarms = farmList;
      });
      debugPrint("✅ User: $userName | 📋 Farms: ${farms.length}");
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error loading data.")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Navigates to the NewFarmScreen and reloads data if a new farm is added.
  void _navigateToNewFarmScreen() async {
    bool? farmAdded = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewFarmScreen()),
    );
    if (farmAdded == true) {
      _loadUserData();
      _showSnackBar(S.of(context)!.farmAddSuccess);
    }
  }

  // Shows a two-step confirmation dialog before archiving a farm.
  Future<void> _confirmDelete(int id) async {
    bool? firstConfirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.archiveFarm),
        content: Text(S.of(context)!.archiveConfirmationContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context)!.confirm),
          ),
        ],
      ),
    );
    if (firstConfirm == true) {
      bool? finalConfirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(S.of(context)!.finalConfirmation),
          content: Text(
            S.of(context)!.archiveWarning,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(S.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(S.of(context)!.confirm, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (finalConfirm == true) {
        _archiveFarm(id);
      }
    }
  }

  // Archives the farm and its associated expenses.
  void _archiveFarm(int id) async {
    int farmResult = await DatabaseHelper().archiveFarm(id);
    int expenseResult = await DatabaseHelper().archiveExpense(id);
    if (farmResult > 0 && expenseResult >= 0) {
      _loadUserData();
      _showSnackBar(S.of(context)!.archiveFarm);
    } else {
      _showSnackBar(S.of(context)!.archiveFailed);
    }
  }

  // Navigates to the EditFarmScreen for updating farm details.
  void _editFarm(int farmId, String farmName, String location) async {
    bool? updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFarmScreen(
          farmId: farmId,
          initialName: farmName,
          initialLocation: location,
        ),
      ),
    );
    if (updated == true) {
      _loadUserData();
      _showSnackBar(S.of(context)!.farmAddSuccess);
    }
  }

  // Filters the farm list based on search query.
  void _filterFarms(String query) {
    setState(() {
      filteredFarms = farms
          .where((farm) =>
          farm['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Displays a SnackBar with the provided message.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Builds the expense summary section with overall and farm-wise details.
  Widget _buildExpenseSummarySection() {
    return FutureBuilder(
      future: DatabaseHelper().getExpenseSummary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          // Show error feedback in UI if needed.
          return Center(child: Text(S.of(context)!.expenseError));
        }
        final List<Map<String, dynamic>> summary =
        snapshot.data as List<Map<String, dynamic>>;
        double overallExpense = 0;
        for (var element in summary) {
          overallExpense += (element["total"] as num).toDouble();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallExpenseCard(overallExpense),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showFarmWiseExpenses = !_showFarmWiseExpenses;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      S.of(context)!.farmWiseExpense,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Icon(
                      _showFarmWiseExpenses
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.teal,
                      size: 28,
                    )
                  ],
                ),
              ),
            ),
            if (_showFarmWiseExpenses)
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: summary.length,
                  itemBuilder: (context, index) {
                    final item = summary[index];
                    return _buildFarmExpenseCard(item);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  // Builds the overall expense card.
  Widget _buildOverallExpenseCard(double overallExpense) {
    const String cardNumberPlaceholder = "**** **** **** 7263";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF651FFF), Color(0xFF6200EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context)!.overallExpense,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "₹${overallExpense.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardNumberPlaceholder,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 16,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white70,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds a card for a specific farm expense.
  Widget _buildFarmExpenseCard(Map<String, dynamic> farmData) {
    final String farmName = farmData["farm_name"] ?? "Unknown Farm";
    final double total = (farmData["total"] as num).toDouble();
    return GestureDetector(
      onTap: () {
        // Navigate to detailed expense view if needed.
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF02AAB0), Color(0xFF00CDAC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              farmName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
             Text(
              S.of(context)!.expense,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "₹${total.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a drawer item.
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.hiFarmer),
        backgroundColor: Colors.teal,
        elevation: 3,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              accountName: Text(
                userName,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("*****10907"),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.teal),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.timeline, "Timeline", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimelineScreen()),
                    );
                  }),
                  _buildDrawerItem(Icons.archive, "Archived Farm Data", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestoreFarmScreen()),
                    ).then((_) => _loadUserData());
                  }),
                  _buildDrawerItem(Icons.timeline, "Archived Expenses", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestoreExpenseScreen()),
                    );
                  }),
                  _buildDrawerItem(Icons.download, "Download Data", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DownloadDataScreen()),
                    );
                  }),


                  const Divider(),
                  _buildDrawerItem(Icons.language, "Change Language", () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeLanguageScreen()),
                  );}),
                  _buildDrawerItem(
                      Icons.contact_support, "Contact Us", () {}),
                  _buildDrawerItem(Icons.info, "About Us", () {}),
                  _buildDrawerItem(Icons.star_rate, "Rate Us", () {}),
                  _buildDrawerItem(Icons.share, "Share App", () {}),
                  _buildDrawerItem(Icons.help, "FAQ", () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Welcome & Search Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Welcome, $userName!",
                //   style: const TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.teal,
                //   ),
                // ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: _filterFarms,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: S.of(context)!.searchFarm,
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expense Summary Section
          _buildExpenseSummarySection(),
          // Farms List Section
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: filteredFarms.isEmpty
                ? Center(
              child: Text(
                S.of(context)!.noFarmsFound,
                style:
                const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFarms.length,
              itemBuilder: (context, index) {
                var farm = filteredFarms[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal[100],
                      child: const Icon(
                          Icons.agriculture, color: Colors.teal),
                    ),
                    title: Text(
                      farm['name'] ?? 'Unknown Farm',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Location: ${farm['location'] ?? 'N/A'}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseListScreen(
                                  farmId: farm['id']),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue),
                          onPressed: () => _editFarm(
                            farm['id'],
                            farm['name'],
                            farm['location'] ?? 'N/A',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () =>
                              _confirmDelete(farm['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewFarmScreen,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
