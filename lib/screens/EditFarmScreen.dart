import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../generated/l10n.dart';

class EditFarmScreen extends StatefulWidget {
  final int farmId;
  final String initialName;
  final String initialLocation;

  const EditFarmScreen({
    super.key,
    required this.farmId,
    required this.initialName,
    required this.initialLocation,
  });

  @override
  _EditFarmScreenState createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends State<EditFarmScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _locationController.text = widget.initialLocation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateFarm() async {
    if (_nameController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context)!.enterNameAndLocation),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> updatedData = {
      'name': _nameController.text.trim(),
      'location': _locationController.text.trim(),
    };

    int result = await DatabaseHelper().updateFarm(widget.farmId, updatedData);

    if (result > 0) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.failedToUpdateFarm)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.editFarm, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context)!.editFarmDetails,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                    SizedBox(height: 12),

                    // Farm Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.farmName,
                        prefixIcon: Icon(Icons.agriculture, color: Colors.teal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Location Field
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.location,
                        prefixIcon: Icon(Icons.location_on, color: Colors.teal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // Improved Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateFarm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.teal.shade800;
                    }
                    return Colors.teal;
                  }),
                ),
                child: Text(S.of(context)!.updateFarm,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
