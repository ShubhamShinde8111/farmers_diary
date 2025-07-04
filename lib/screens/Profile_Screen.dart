import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final String apiUrl = "https://raw.githubusercontent.com/pranshumaheshwari/indian-cities-and-villages/refs/heads/master/data.json";

  Map<String, Map<String, Map<String, List<String>>>> indiaData = {};
  List<String> states = [];
  List<String> districts = [];
  List<String> subDistricts = [];
  List<String> villages = [];

  String? selectedState;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedVillage;


  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> rawData = json.decode(response.body);

        if (rawData.isEmpty) {
          throw Exception("Empty data received.");
        }

        Map<String, Map<String, Map<String, List<String>>>> formattedData = {};
        List<String> stateList = [];

        for (var state in rawData) {
          if (state is Map<String, dynamic>) {
            String? stateName = state['state'] as String?;
            var districtData = state['districts'] as Map<String, dynamic>?;

            if (stateName != null && districtData != null) {
              stateList.add(stateName);
              formattedData[stateName] = {};

              districtData.forEach((districtName, subDistricts) {
                if (subDistricts is Map<String, dynamic>) {
                  formattedData[stateName]![districtName] = {};
                  subDistricts.forEach((subDistrictName, villagesList) {
                    if (villagesList is List<dynamic>) {
                      formattedData[stateName]![districtName]![subDistrictName] =
                          villagesList.cast<String>();
                    }
                  });
                }
              });
            }
          }
        }

        setState(() {
          indiaData = formattedData;
          states = stateList;
        });

        print("States updated: ${states.length} states available.");
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  void fetchSubDistricts(String district) {
    if (selectedState != null && indiaData.containsKey(selectedState)) {
      var districtData = indiaData[selectedState]!;
      if (districtData.containsKey(district)) {
        setState(() {
          subDistricts = districtData[district]!.keys.toList();
          selectedSubDistrict = null;
          selectedVillage = null;
        });
      }
    }
  }

  void fetchVillages(String subDistrict) {
    if (selectedState != null &&
        selectedDistrict != null &&
        indiaData[selectedState] != null &&
        indiaData[selectedState]!.containsKey(selectedDistrict!)) {
      var subDistrictData = indiaData[selectedState]![selectedDistrict!]!;
      if (subDistrictData.containsKey(subDistrict)) {
        setState(() {
          villages = subDistrictData[subDistrict]!;
          selectedVillage = null;
        });
      }
    }
  }


  void _updateProfile() {
    print("Profile Updated: $selectedState, $selectedDistrict, $selectedSubDistrict, $selectedVillage");
    // Save to SQLite or local storage if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: fetchStates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading states")); // Error state
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.teal.withOpacity(0.2),
                        child: Icon(Icons.person, size: 50, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField("Name", nameController),
                    _buildTextField("Email ID", emailController),

                    // ✅ State Dropdown (Wrap with FutureBuilder)
                    _buildDropdown("State", selectedState, states, (value) {
                      setState(() {
                        selectedState = value;
                        selectedDistrict = null;
                        selectedSubDistrict = null;
                        selectedVillage = null;
                        districts = indiaData[value]?.keys.toList() ?? [];
                      });
                    }),

                    // ✅ District Dropdown
                    if (selectedState != null)
                      _buildDropdown("District", selectedDistrict, districts, (value) {
                        setState(() {
                          selectedDistrict = value;
                          selectedSubDistrict = null;
                          selectedVillage = null;
                          fetchSubDistricts(value!);
                        });
                      }),

                    // ✅ SubDistrict Dropdown
                    if (selectedDistrict != null)
                      _buildDropdown("Sub-District", selectedSubDistrict, subDistricts, (value) {
                        setState(() {
                          selectedSubDistrict = value;
                          selectedVillage = null;
                          fetchVillages(value!);
                        });
                      }),

                    // ✅ Village Dropdown
                    if (selectedSubDistrict != null)
                      _buildDropdown("Village", selectedVillage, villages, (value) {
                        setState(() {
                          selectedVillage = value;
                        });
                      }),

                    SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text("Save Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: (value != null && items.contains(value)) ? value : null, // Prevent invalid selections
          items: items.isNotEmpty
              ? items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList()
              : [],
          onChanged: items.isNotEmpty ? onChanged : null, // Disable dropdown if no items
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: "Select $label", // Add placeholder text
          ),
          isDense: true, // Reduce dropdown height
          isExpanded: true, // Ensure full width
          icon: Icon(Icons.arrow_drop_down, color: Colors.teal), // Improve visibility
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }


}
