import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CropSelectionScreen extends StatefulWidget {
  const CropSelectionScreen({super.key});

  @override
  _CropSelectionScreenState createState() => _CropSelectionScreenState();
}

class _CropSelectionScreenState extends State<CropSelectionScreen> {
  final List<String> cropCategories = ["Fruits", "Vegetables", "Grains", "Others"];
  String? selectedCrop;
  String? userName;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCrop = prefs.getString('selected_crop');
      userName = prefs.getString('user_name');
    });

    if (userName == null || userName!.isEmpty) {
      _askForUserName();
    }
  }

  Future<void> _askForUserName() async {
    String? enteredName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Your Name"),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(hintText: "Your Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_nameController.text.trim());
            },
            child: Text("Save"),
          ),
        ],
      ),
    );

    if (enteredName != null && enteredName.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', enteredName);
      setState(() {
        userName = enteredName;
      });
    }
  }

  Future<void> _saveSelectedCrop(String crop) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_crop', crop);
    setState(() {
      selectedCrop = crop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${userName ?? 'User'}")),
      body: Column(
        children: [
          if (selectedCrop != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Selected Crop: $selectedCrop", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cropCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _saveSelectedCrop(cropCategories[index]),
                  child: Card(
                    color: selectedCrop == cropCategories[index] ? Colors.green[200] : Colors.white,
                    child: Center(
                      child: Text(
                        cropCategories[index],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
