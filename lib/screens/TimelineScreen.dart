import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../database/database_helper.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> _farms = [];
  int? _selectedFarmId;
  List<Map<String, dynamic>> _timelineData = [];

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    try {
      List<Map<String, dynamic>> farmList = await _dbHelper.getAllFarms();
      setState(() {
        _farms = farmList;
        if (_farms.isNotEmpty) {
          _selectedFarmId = _farms[0]['id'];
        }
      });
      if (_selectedFarmId != null) {
        _loadTimelineData(_selectedFarmId!);
      }
    } catch (e) {
      debugPrint("❌ Error loading farms: $e");
    }
  }

  Future<void> _loadTimelineData(int farmId) async {
    try {
      List<Map<String, dynamic>> data =
      await _dbHelper.getDayWiseExpensesForFarm(farmId);
      setState(() {
        _timelineData = List.from(data);
      });
    } catch (e) {
      debugPrint("❌ Error loading timeline data: $e");
    }
  }

  void _onFarmSelected(int farmId) {
    setState(() {
      _timelineData = [];
      _selectedFarmId = farmId;
    });
    _loadTimelineData(farmId);
  }

  String _formatDate(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat("MMM d").format(parsedDate);
  }

  // Convert each category into a "Chip"
  Widget _buildCategoryChip(String category) {
    IconData iconData;
    Color color;
    switch (category.trim()) {
      case 'Seeds':
        iconData = Icons.grass;
        color = Colors.green.shade400;
        break;
      case 'Fertilizer':
        iconData = Icons.eco;
        color = Colors.brown.shade300;
        break;
      case 'Labor':
        iconData = Icons.person;
        color = Colors.blue.shade300;
        break;
      case 'Equipment':
        iconData = Icons.agriculture;
        color = Colors.orange.shade300;
        break;
      case 'Irrigation':
        iconData = Icons.opacity;
        color = Colors.blue.shade200;
        break;
      default:
        iconData = Icons.miscellaneous_services;
        color = Colors.grey.shade400;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            category.trim(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the default background so our wave can show
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Wavy header behind the "AppBar"
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF009688), Color(0xFF48C9B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Main content in a column
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom "AppBar"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    "Timeline",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Horizontal farm avatars list
                if (_farms.isNotEmpty)
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _farms.length,
                      itemBuilder: (context, index) {
                        final farm = _farms[index];
                        final isSelected = (farm['id'] == _selectedFarmId);
                        return GestureDetector(
                          onTap: () => _onFarmSelected(farm['id']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal.shade50 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  isSelected ? Colors.teal : Colors.grey[300],
                                  radius: 28,
                                  child: Text(
                                    farm['name'][0].toUpperCase(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    farm['name'],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected ? Colors.teal : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // Timeline list
                Expanded(
                  child: Container(
                    // Slight top margin so list doesn't overlap with wave
                    margin: const EdgeInsets.only(top: 8),
                    child: _timelineData.isEmpty
                        ? Center(
                      child: Text(
                        _selectedFarmId == null
                            ? "No farms available."
                            : "No timeline data found.",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      itemCount: _timelineData.length,
                      itemBuilder: (context, index) {
                        final row = _timelineData[index];
                        final dateStr = row['date'] as String;
                        final total = row['total'];
                        final categories =
                            (row['categories'] as String?)?.split(',') ?? [];

                        return _buildTimelineItem(
                          dateStr: dateStr,
                          total: total,
                          categories: categories,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Single timeline card item
  Widget _buildTimelineItem({
    required String dateStr,
    required dynamic total,
    required List<String> categories,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date label
            SizedBox(
              width: 60,
              child: Text(
                _formatDate(dateStr),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            // Timeline vertical line
            Container(
              width: 2,
              height: 80,
              color: Colors.teal,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            // Expense info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the total expense
                  Text(
                    "₹$total",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display category chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories
                          .toSet() // remove duplicates
                          .map<Widget>((cat) => _buildCategoryChip(cat))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A custom clipper for creating the wave effect at the top
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Customize these values to change the wave shape
    final path = Path();
    path.lineTo(0, size.height * 0.7);

    // First control point (start of the wave)
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.8);

    // Second control point (end of the wave)
    final secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.8);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
