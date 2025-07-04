import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../generated/l10n.dart';

/// Enum for work types. Use these keys to store in your database.
enum WorkType {
  seeds,
  fertilizer,
  labor,
  equipment,
  irrigation,
  harvesting,
  weeding,
  pesticideSpraying,
  planting,
  pruning,
  soilTesting,
  composting,
}

/// Enum for unit types.
enum Unit {
  kilogram,
  liters,
  pieces,
  gram,
}

class AddEditExpenseScreen extends StatefulWidget {
  final int farmId;
  // When editing, expenseData should store a constant key for work type and unit.
  final Map<String, dynamic>? expenseData;

  AddEditExpenseScreen({required this.farmId, this.expenseData});

  @override
  _AddEditExpenseScreenState createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields.
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _workNameController = TextEditingController();

  // Use enums instead of localized strings for constant keys.
  WorkType? _selectedWorkType;
  Unit? _selectedUnit;
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isEditing = false;


  String _convertNepaliToEnglishDigits(String input) {
    const nepaliMap = {
      '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
      '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
    };
    return input.split('').map((ch) => nepaliMap[ch] ?? ch).join();
  }


  // -------------------------------------------------------
  // Helper functions for WorkType mapping.
  // -------------------------------------------------------

  /// Returns the localized display text for the given [workType].
  String _getWorkTypeLabel(WorkType workType) {
    switch (workType) {
      case WorkType.seeds:
        return S.of(context)!.seeds;
      case WorkType.fertilizer:
        return S.of(context)!.fertilizer;
      case WorkType.labor:
        return S.of(context)!.labor;
      case WorkType.equipment:
        return S.of(context)!.equipment;
      case WorkType.irrigation:
        return S.of(context)!.irrigation;
      case WorkType.harvesting:
        return S.of(context)!.harvesting;
      case WorkType.weeding:
        return S.of(context)!.weeding;
      case WorkType.pesticideSpraying:
        return S.of(context)!.pesticideSpraying;
      case WorkType.planting:
        return S.of(context)!.planting;
      case WorkType.pruning:
        return S.of(context)!.pruning;
      case WorkType.soilTesting:
        return S.of(context)!.soilTesting;
      case WorkType.composting:
        return S.of(context)!.composting;
    }
  }

  /// Converts a stored string (constant key) to [WorkType].
  WorkType? _stringToWorkType(String? storedValue) {
    if (storedValue == null) return null;
    for (var wt in WorkType.values) {
      if (wt.toString().split('.').last == storedValue) {
        return wt;
      }
    }
    return null;
  }

  WorkType? _convertLegacyWorkType(String storedValue) {
    for (var wt in WorkType.values) {
      if (storedValue == _getWorkTypeLabel(wt)) {
        return wt;
      }
    }
    return null;
  }

  String _workTypeToString(WorkType workType) => workType.toString().split('.').last;


  /// Returns the constant key string for a given work type.
  // String _workTypeToString(WorkType workType) {
  //   return workType.toString().split('.').last;
  // }

  // -------------------------------------------------------
  // Helper functions for Unit mapping.
  // -------------------------------------------------------

  /// Returns the localized display text for the given [unit].
  String _getUnitLabel(Unit unit) {
    switch (unit) {
      case Unit.kilogram:
        return S.of(context)!.kilogram;
      case Unit.liters:
        return S.of(context)!.liters;
      case Unit.pieces:
        return S.of(context)!.pieces;
      case Unit.gram:
        return S.of(context)!.gram;
    }
  }

  Unit? _stringToUnit(String? storedValue) {
    if (storedValue == null) return null;
    for (var u in Unit.values) {
      if (u.toString().split('.').last == storedValue) {
        return u;
      }
    }
    return null;
  }

  /// Legacy conversion for unit:
  /// If storedValue is a localized string, try matching it.
  Unit? _convertLegacyUnit(String storedValue) {
    for (var u in Unit.values) {
      if (storedValue == _getUnitLabel(u)) {
        return u;
      }
    }
    return null;
  }

  String _unitToString(Unit unit) => unit.toString().split('.').last;

  @override
  void initState() {
    super.initState();
    if (widget.expenseData != null) {
      _isEditing = true;
      // WorkType
      final storedWorkTypeValue = widget.expenseData!['category'];
      if (storedWorkTypeValue is String) {
        _selectedWorkType = _stringToWorkType(storedWorkTypeValue);
      }
      // Unit
      if (widget.expenseData!.containsKey('unit')) {
        final storedUnitValue = widget.expenseData!['unit'];
        if (storedUnitValue is String) {
          _selectedUnit = _stringToUnit(storedUnitValue);
        }
      }
      // Amount & notes
      _amountController.text = widget.expenseData!['amount']?.toString() ?? '';
      _notesController.text = widget.expenseData!['notes'] ?? '';
      // Date with Nepali digit cleanup
      final dateValue = widget.expenseData!['date'];
      if (dateValue is String) {
        final englishDate = _convertNepaliToEnglishDigits(dateValue);
        _selectedDate = DateTime.tryParse(englishDate) ?? DateTime.now();
      }
      // Image
      final imagePath = widget.expenseData!['image_path'];
      if (imagePath is String && imagePath.isNotEmpty) {
        _selectedImage = File(imagePath);
      }
      // Quantity & work name
      if (widget.expenseData!.containsKey('quantity')) {
        _quantityController.text = widget.expenseData!['quantity']?.toString() ?? '';
      }
      if (widget.expenseData!.containsKey('work_name')) {
        _workNameController.text = widget.expenseData!['work_name'] ?? '';
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.expenseData != null) {
      // Legacy fallback
      if (_selectedWorkType == null) {
        final legacyWork = widget.expenseData!['category'];
        if (legacyWork is String) {
          _selectedWorkType = _convertLegacyWorkType(legacyWork);
        }
      }
      if (_selectedUnit == null && widget.expenseData!.containsKey('unit')) {
        final legacyUnit = widget.expenseData!['unit'];
        if (legacyUnit is String) {
          _selectedUnit = _convertLegacyUnit(legacyUnit);
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    _workNameController.dispose();
    super.dispose();
  }

  // Pick an image from the given [source].
  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Shows a bottom sheet for selecting image source.
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Save or update expense in the database.
  void _saveExpense() async {
    if (_formKey.currentState!.validate() &&
        _selectedWorkType != null) {
      Map<String, dynamic> expenseData = {
        'farm_id': widget.farmId,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        // Save constant key for work type.
        'category': _workTypeToString(_selectedWorkType!),
        'amount': double.parse(_amountController.text),
        'notes': _notesController.text.trim(),
        'image_path': _selectedImage?.path,
        'work_name': _workNameController.text.trim(),
      };

      if (_selectedWorkType == WorkType.seeds ||
          _selectedWorkType == WorkType.fertilizer) {
        expenseData['quantity'] =
            double.tryParse(_quantityController.text) ?? 0;
        // Save constant key for unit.
        expenseData['unit'] =
        _selectedUnit != null ? _unitToString(_selectedUnit!) : "N/A";
      }

      try {
        if (_isEditing) {
          await DatabaseHelper()
              .updateExpense(widget.expenseData!['id'], expenseData);
        } else {
          await DatabaseHelper().insertExpense(expenseData);
        }
        Navigator.pop(context, true);
      } catch (e) {
        debugPrint("❌ Error saving expense: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.failedToSaveExpense)),
        );
      }
    }
  }

  // Pick a date using the date picker.
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the dropdown items for work types.
    List<DropdownMenuItem<WorkType>> workTypeItems =
    WorkType.values.map((workType) {
      return DropdownMenuItem(
        value: workType,
        child: Text(_getWorkTypeLabel(workType)),
      );
    }).toList();

    // Build the dropdown items for units.
    List<DropdownMenuItem<Unit>> unitItems = Unit.values.map((unit) {
      return DropdownMenuItem(
        value: unit,
        child: Text(_getUnitLabel(unit)),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              // Date Picker
              Text("Date:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('MMMM d, yyyy').format(_selectedDate),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Work Type Dropdown
              Text(S.of(context)!.selectWorkType,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              DropdownButtonFormField<WorkType>(
                value: _selectedWorkType,
                hint: Text(S.of(context)!.selectWorkType),
                onChanged: (WorkType? value) {
                  setState(() {
                    _selectedWorkType = value;
                    _quantityController.clear();
                    _selectedUnit = null;
                  });
                },
                validator: (WorkType? value) {
                  if (value == null) {
                    return S.of(context)!.selectWorkType;
                  }
                  if ((value == WorkType.seeds ||
                      value == WorkType.fertilizer) &&
                      (_quantityController.text.isEmpty ||
                          _selectedUnit == null)) {
                    return S.of(context)!.quantityUnitRequired;
                  }
                  if ((_quantityController.text.isNotEmpty ||
                      _selectedUnit != null) &&
                      (_workNameController.text.isEmpty)) {
                    return S.of(context)!.workNameRequired;
                  }
                  return null;
                },
                items: workTypeItems,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Work Name Field
              Text(S.of(context)!.workName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              TextFormField(
                controller: _workNameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: S.of(context)!.enterWorkName,
                ),
                validator: (value) {
                  if (_selectedWorkType != WorkType.labor &&
                      (value == null || value.trim().isEmpty)) {
                    return S.of(context)!.workNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Conditional fields for Seeds/Fertilizer
              if (_selectedWorkType == WorkType.seeds ||
                  _selectedWorkType == WorkType.fertilizer) ...[
                Text(S.of(context)!.quantity,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: S.of(context)!.enterQuantity,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context)!.quantityRequired;
                    }
                    if (double.tryParse(value) == null) {
                      return S.of(context)!.enterValidNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Text(S.of(context)!.unit,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                DropdownButtonFormField<Unit>(
                  value: _selectedUnit,
                  hint: Text(S.of(context)!.unit),
                  onChanged: (Unit? value) {
                    setState(() {
                      _selectedUnit = value;
                    });
                  },
                  items: unitItems,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null ? S.of(context)!.unitRequired : null,
                ),
                const SizedBox(height: 15),
              ],

              // Amount Field
              Text(S.of(context)!.amount,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: S.of(context)!.enterAmount,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.of(context)!.amountRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return S.of(context)!.enterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Work Description Field
              Text(S.of(context)!.workDescription,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              TextFormField(
                controller: _notesController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: S.of(context)!.enterWorkDescription,
                ),
              ),
              const SizedBox(height: 15),

              // Receipt Upload (Asset Issue Note)
              // Note: Ensure you have declared the asset "assets/images/pattern.png"
              // in your pubspec.yaml under flutter/assets.
              Text(S.of(context)!.receipts,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _showImageSourceActionSheet,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage == null
                      ? Center(
                    child: Icon(Icons.add_a_photo,
                        color: Colors.teal, size: 40),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveExpense();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text(S.of(context)!.pleaseFillAllFields),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.tealAccent,
                  elevation: 6,
                ),
                child: Text(
                  S.of(context)!.recordWorkExpense,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
