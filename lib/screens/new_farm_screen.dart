import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../generated/l10n.dart';

class NewFarmScreen extends StatefulWidget {
  const NewFarmScreen({super.key});

  @override
  _NewFarmScreenState createState() => _NewFarmScreenState();
}

class _NewFarmScreenState extends State<NewFarmScreen> {
  String? selectedCrop;
  String? selectedAreaUnit;
  String? selectedQuantityUnit;
  TextEditingController farmNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final crops = [
    {
      "en": "Bajra",
      "hi": "बाजरा",
      "mr": "बाजरी",
      "icon": "lib/assets/crops/bajri.png"
    },
    {
      "en": "Banana",
      "hi": "केला",
      "mr": "केळी",
      "icon": "lib/assets/crops/kali.png"
    },
    {
      "en": "Bitter Gourd",
      "hi": "करेला",
      "mr": "कारले",
      "icon": "lib/assets/crops/karle.png"
    },
    {
      "en": "Bottle Gourd",
      "hi": "लौकी",
      "mr": "दुधी भोपळा",
      "icon": "lib/assets/crops/dudhi.png"
    },
    {
      "en": "Brinjal",
      "hi": "बैंगन",
      "mr": "वांगी",
      "icon": "lib/assets/crops/vangi.jpg"
    },
    {
      "en": "Cabbage",
      "hi": "पत्ता गोभी",
      "mr": "कोबी",
      "icon": "lib/assets/crops/kobi.jpg"
    },
    {
      "en": "Capsicum",
      "hi": "शिमला मिर्च",
      "mr": "सिमला मिरची",
      "icon": "lib/assets/crops/simla_mirchi.png"
    },
    {
      "en": "Cauliflower",
      "hi": "फूलगोभी",
      "mr": "फ्लॉवर",
      "icon": "lib/assets/crops/flower.png"
    },
    {
      "en": "Chili",
      "hi": "मिर्ची",
      "mr": "मिरची",
      "icon": "lib/assets/crops/mirchi.png"
    },
    {
      "en": "Corn",
      "hi": "मक्का",
      "mr": "मका",
      "icon": "lib/assets/crops/maka.png"
    },
    {
      "en": "Cotton",
      "hi": "कपास",
      "mr": "कापूस",
      "icon": "lib/assets/crops/kapus.png"
    },
    {
      "en": "Cucumber",
      "hi": "खीरा",
      "mr": "काकडी",
      "icon": "lib/assets/crops/kakdi.png"
    },
    {
      "en": "Custard Apple",
      "hi": "सीताफल",
      "mr": "सिताफळ",
      "icon": "lib/assets/crops/sitafal.png"
    },
    {
      "en": "Drumstick",
      "hi": "सहजन",
      "mr": "शेवगा",
      "icon": "lib/assets/crops/shevga.png"
    },
    {
      "en": "Fenugreek",
      "hi": "मेथी",
      "mr": "मेथी",
      "icon": "lib/assets/crops/methi.png"
    },
    {
      "en": "Flat Beans",
      "hi": "सेम",
      "mr": "घेवडा",
      "icon": "lib/assets/crops/ghevda.png"
    },
    {
      "en": "Ginger",
      "hi": "अदरक",
      "mr": "आले",
      "icon": "lib/assets/crops/ale.png"
    },
    {
      "en": "Grapes",
      "hi": "अंगूर",
      "mr": "द्राक्षे",
      "icon": "lib/assets/crops/drax.png"
    },
    {
      "en": "Groundnut",
      "hi": "मूंगफली",
      "mr": "भुईमूग",
      "icon": "lib/assets/crops/bhuimug.png"
    },
    {
      "en": "Guava",
      "hi": "अमरूद",
      "mr": "पेरू",
      "icon": "lib/assets/crops/peru.png"
    },
    {
      "en": "Chickpea (Green)",
      "hi": "हरा चना",
      "mr": "हरभरा",
      "icon": "lib/assets/crops/harbhara.png"
    },
    {
      "en": "Wheat",
      "hi": "गेहूं",
      "mr": "गहू",
      "icon": "lib/assets/crops/wheat.png"
    },
    {
      "en": "Rice",
      "hi": "चावल",
      "mr": "तांदूळ",
      "icon": "lib/assets/crops/rice.png"
    },
    {
      "en": "Jowar",
      "hi": "ज्वार",
      "mr": "ज्वारी",
      "icon": "lib/assets/crops/jowar.png"
    },
    {
      "en": "Sugarcane",
      "hi": "गन्ना",
      "mr": "ऊस",
      "icon": "lib/assets/crops/sugarcane.png"
    },
    {
      "en": "Soybean",
      "hi": "सोयाबीन",
      "mr": "सोयाबीन",
      "icon": "lib/assets/crops/soyabean.png"
    },
    {
      "en": "Lentil",
      "hi": "मसूर",
      "mr": "मसूर",
      "icon": "lib/assets/crops/masoor.png"
    },
    {
      "en": "Black Gram",
      "hi": "उड़द",
      "mr": "उडीद",
      "icon": "lib/assets/crops/urad.png"
    },
    {
      "en": "Green Gram",
      "hi": "मूंग",
      "mr": "मुग",
      "icon": "lib/assets/crops/moong.png"
    },
    {
      "en": "Chickpea",
      "hi": "चना",
      "mr": "चना",
      "icon": "lib/assets/crops/chana.png"
    },
    {
      "en": "Potato",
      "hi": "आलू",
      "mr": "बटाटा",
      "icon": "lib/assets/crops/potato.png"
    },
    {
      "en": "Tomato",
      "hi": "टमाटर",
      "mr": "टोमॅटो",
      "icon": "lib/assets/crops/tomato.png"
    },
    {
      "en": "Cluster Beans",
      "hi": "ग्वार फली",
      "mr": "गवार",
      "icon": "lib/assets/crops/guar.png"
    },
    {
      "en": "Pigeon Pea",
      "hi": "अरहर",
      "mr": "तूर",
      "icon": "lib/assets/crops/toor.png"
    },
    {
      "en": "Garlic",
      "hi": "लहसुन",
      "mr": "लसूण",
      "icon": "lib/assets/crops/garlic.png"
    },
    {
      "en": "Onion",
      "hi": "प्याज",
      "mr": "कांदा",
      "icon": "lib/assets/crops/onion.png"
    },
    {
      "en": "Watermelon",
      "hi": "तरबूज",
      "mr": "कलिंगड",
      "icon": "lib/assets/crops/kalingad.png"
    },
    {
      "en": "Orange",
      "hi": "संतरा",
      "mr": "संत्री",
      "icon": "lib/assets/crops/santri.png"
    },
    {
      "en": "Mango",
      "hi": "आम",
      "mr": "आंबा",
      "icon": "lib/assets/crops/mango.png"
    },
    {
      "en": "Papaya",
      "hi": "पपीता",
      "mr": "पपई",
      "icon": "lib/assets/crops/papai.png"
    },
    {
      "en": "Pineapple",
      "hi": "अनानास",
      "mr": "अननस",
      "icon": "lib/assets/crops/ananas.png"
    },
    {
      "en": "Coconut",
      "hi": "नारियल",
      "mr": "नारळ",
      "icon": "lib/assets/crops/naral.png"
    },
    {
      "en": "Pomegranate",
      "hi": "अनार",
      "mr": "डाळिंब",
      "icon": "lib/assets/crops/dalimb.png"
    },
    {
      "en": "Lemon",
      "hi": "नींबू",
      "mr": "लिंबू",
      "icon": "lib/assets/crops/limbu.png"
    },
    {
      "en": "Jamun",
      "hi": "जामुन",
      "mr": "जांभूळ",
      "icon": "lib/assets/crops/jamun.png"
    },
    {
      "en": "Fig",
      "hi": "अंजीर",
      "mr": "अंजीर",
      "icon": "lib/assets/crops/anjeer.png"
    },
    {
      "en": "Sapota",
      "hi": "चीकू",
      "mr": "चीकू",
      "icon": "lib/assets/crops/chikoo.png"
    },

  ];
  String getCropName(Map<String, String> crop, String languageCode, [String fallback = "Unknown Crop"]) {
    switch (languageCode) {
      case 'hi':
        return crop['hi'] ?? fallback; // Return Hindi name
      case 'mr':
        return crop['mr'] ?? fallback; // Return Marathi name
      case 'en':
      default:
        return crop['en'] ?? fallback; // Return English name
    }
  }



  void _showCropSelectionDialog() {
    String languageCode = Localizations.localeOf(context).languageCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context)!.cropTypeSelection,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  S.of(context)!.select_crop_category,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: crops.length + 1, // Add 1 for the "Other" option
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    // Handle "Other" option at the end
                    if (index == crops.length) {
                      return Material(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showCustomCropDialog(); // Open dialog to enter custom crop
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, size: 50, color: Colors.teal),
                              SizedBox(height: 5),
                              Text(
                                S.of(context)!.otherCrop, // Add this key to your .arb files
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    var crop = crops[index];
                    String cropName = getCropName(crop, languageCode);
                    String cropIcon = crop["icon"] ?? '';

                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            selectedCrop = cropName;
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              cropIcon.isNotEmpty
                                  ? Image.asset(
                                cropIcon,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported),
                              )
                                  : Icon(Icons.image_not_supported, size: 50),
                              SizedBox(height: 5),
                              Text(
                                cropName,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text(S.of(context)!.close, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomCropDialog() {
    TextEditingController customCropController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context)!.enterCropName),
          content: TextField(
            controller: customCropController,
            decoration: InputDecoration(
              hintText: S.of(context)!.enterHere,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (customCropController.text.trim().isNotEmpty) {
                  setState(() {
                    selectedCrop = customCropController.text.trim();
                  });
                }
                Navigator.pop(context);
              },
              child: Text(S.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }




  void _submitForm() async {
    if (farmNameController.text.trim().isEmpty ||
        selectedCrop == null ||  // Check if selectedCrop is null
        selectedAreaUnit == null ||
        selectedQuantityUnit == null ||
        areaController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.pleaseFillAllInfo)),
      );
      return;
    }

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.webDataNotSaved)),
      );
      return;
    }

    int result = await DatabaseHelper().insertFarm({
      'name': farmNameController.text.trim(),
      'crop': selectedCrop!, // Ensure selectedCrop is not null before saving
      'area': areaController.text.trim(),
      'area_unit': selectedAreaUnit!,
      'quantity': quantityController.text.trim(),
      'quantity_unit': selectedQuantityUnit!,
      'date': dateController.text.trim(),
    });



    if (result > 0) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.farmSaveError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.addNewFarm, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("वर्ष : 2025",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                    SizedBox(height: 15),

                    _buildLabel(S.of(context)!.cropName),
                    GestureDetector(
                      onTap: _showCropSelectionDialog,
                      child: _buildDropdownField(selectedCrop ?? S.of(context)!.selectCrop, Icons.arrow_drop_down),
                    ),
                    SizedBox(height: 15),

                    _buildLabel(S.of(context)!.farmName),
                    _buildTextField(farmNameController, S.of(context)!.farmName),
                    SizedBox(height: 15),

                    _buildLabel(S.of(context)!.area),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                [S.of(context)!.acre,S.of(context)!.hectare, S.of(context)!.gunta, S.of(context)!.squareMeter, S.of(context)!.squareFoot],
                                selectedAreaUnit,
                                    (val) => setState(() => selectedAreaUnit = val)
                            )
                        ),
                        SizedBox(width: 15),
                        Expanded(
                            child: _buildTextField(areaController,S.of(context)!.enterQuantity, isNumber: true)
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    _buildLabel(S.of(context)!.seedlingCount),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                [S.of(context)!.number, S.of(context)!.dozen,S.of(context)!.kilogram, S.of(context)!.gram],
                                selectedQuantityUnit,
                                    (val) => setState(() => selectedQuantityUnit = val)
                            )
                        ),
                        SizedBox(width: 15),
                        Expanded(
                            child: _buildTextField(quantityController, S.of(context)!.enterQuantity, isNumber: true)
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    _buildLabel(S.of(context)!.plantingDate),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          });
                        }
                      },
                      child: _buildDropdownField(dateController.text.isEmpty ? S.of(context)!.enterQuantity : dateController.text, Icons.calendar_today),
                    ),
                    SizedBox(height: 25),

                    // ✅ Improved Button with gradient and smooth UI
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Transparent to allow gradient
                            shadowColor: Colors.transparent, // No extra shadow
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(S.of(context)!.addNewFarm,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLabel(String text) => Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: hint),
    );
  }

  Widget _buildDropdown(List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true, // Allows the dropdown to take up available space
      items: items.map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }


  Widget _buildDropdownField(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(text), Icon(icon)]),
    );
  }
}
