import 'package:flutter/material.dart';
import 'dart:io';

class ExpenseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> expense;

  ExpenseDetailScreen({required this.expense});

  @override
  Widget build(BuildContext context) {
    String? imagePath = expense['image_path'];
    bool hasImage = imagePath != null &&
        imagePath.isNotEmpty &&
        File(imagePath).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imagePath),
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildDetailItem(
                    icon: Icons.category,
                    title: "Category",
                    value: expense['category'],
                  ),
                  const Divider(),
                  _buildDetailItem(
                    icon: Icons.attach_money,
                    title: "Amount",
                    value: "₹${expense['amount']}",
                  ),
                  const Divider(),
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: "Date",
                    value: expense['date'],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expense['notes'] ?? 'No notes',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      {required IconData icon,
        required String title,
        required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Text(
          "$title: ",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
