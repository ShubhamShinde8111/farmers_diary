import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  // Singleton instance and private constructor
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Getter for the database instance
  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("⚠️ Sqflite is not supported on Flutter Web.");
    }
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Use sqfliteFfi on desktop platforms
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'farm_tracker.db');

    return await openDatabase(
      path,
      version: 9, // Bumped version to 9 to force upgrade
      onCreate: (db, version) async {
        debugPrint("🔹 Creating database...");

        // Create the farms table
        await db.execute('''
          CREATE TABLE farms(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            location TEXT,
            crop TEXT,
            area REAL,
            area_unit TEXT,
            quantity REAL,
            quantity_unit TEXT,
            date TEXT,
            is_archived INTEGER DEFAULT 0
          )
        ''');

        // Create the expenses table with a foreign key to farms
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            farm_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            notes TEXT,
            image_path TEXT,
            work_name TEXT,
            quantity REAL,
            unit TEXT,
            is_archived INTEGER DEFAULT 0,
            FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
          )
        ''');

        // Create an index for farm_id in expenses to speed up queries
        await db.execute("CREATE INDEX idx_farm_id ON expenses(farm_id)");
        debugPrint("✅ Database created successfully.");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        debugPrint(
            "🔄 Upgrading database from version $oldVersion to $newVersion...");

        // For all upgrade cases below, oldVersion < 9
        if (oldVersion < 9) {
          // Upgrade farms table: add is_archived if missing.
          List<Map<String, dynamic>> farmColumns =
          await db.rawQuery("PRAGMA table_info(farms);");
          bool hasIsArchived =
          farmColumns.any((column) => column['name'] == 'is_archived');
          if (!hasIsArchived) {
            debugPrint(
                "❌ `is_archived` column missing in farms table! Adding it now...");
            await db.execute(
                "ALTER TABLE farms ADD COLUMN is_archived INTEGER DEFAULT 0");
          }

          // Upgrade expenses table: add is_archived if missing.
          List<Map<String, dynamic>> expenseColumns =
          await db.rawQuery("PRAGMA table_info(expenses);");
          bool expenseHasIsArchived =
          expenseColumns.any((column) => column['name'] == 'is_archived');
          if (!expenseHasIsArchived) {
            debugPrint(
                "❌ `is_archived` column missing in expenses table! Adding it now...");
            await db.execute(
                "ALTER TABLE expenses ADD COLUMN is_archived INTEGER DEFAULT 0");
          }

          // Upgrade expenses table: add image_path column if missing.
          bool hasImagePath = expenseColumns
              .any((column) => column['name'] == 'image_path');
          if (!hasImagePath) {
            debugPrint(
                "❌ `image_path` column missing in expenses table! Adding it now...");
            await db.execute("ALTER TABLE expenses ADD COLUMN image_path TEXT");
          }

          // Upgrade expenses table: add work_name, quantity, and unit columns if missing.
          bool hasWorkName =
          expenseColumns.any((column) => column['name'] == 'work_name');
          bool hasQuantity =
          expenseColumns.any((column) => column['name'] == 'quantity');
          bool hasUnit =
          expenseColumns.any((column) => column['name'] == 'unit');

          if (!hasWorkName) {
            debugPrint(
                "❌ `work_name` column missing in expenses table! Adding it now...");
            await db.execute("ALTER TABLE expenses ADD COLUMN work_name TEXT");
          }
          if (!hasQuantity) {
            debugPrint(
                "❌ `quantity` column missing in expenses table! Adding it now...");
            await db.execute("ALTER TABLE expenses ADD COLUMN quantity REAL");
          }
          if (!hasUnit) {
            debugPrint(
                "❌ `unit` column missing in expenses table! Adding it now...");
            await db.execute("ALTER TABLE expenses ADD COLUMN unit TEXT");
          }
        }

        debugPrint("✅ Database upgrade completed.");
      },
    );
  }

  // CRUD operations for farms and expenses:

  Future<int> archiveFarm(int id) async {
    try {
      final db = await database;
      return await db
          .update('farms', {'is_archived': 1}, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error archiving farm: $e");
      return -1;
    }
  }

  Future<int> archiveExpense(int id) async {
    try {
      final db = await database;
      return await db.update('expenses', {'is_archived': 1},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error archiving expense: $e");
      return -1;
    }
  }

  Future<int> insertFarm(Map<String, dynamic> farmData) async {
    try {
      final db = await database;
      return await db.insert('farms', farmData);
    } catch (e) {
      debugPrint("❌ Error inserting farm: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllFarms() async {
    try {
      final db = await database;
      return await db.query('farms', where: 'is_archived = ?', whereArgs: [0]);
    } catch (e) {
      debugPrint("❌ Error fetching farms: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getArchivedFarms() async {
    try {
      final db = await database;
      return await db.query('farms', where: 'is_archived = ?', whereArgs: [1]);
    } catch (e) {
      debugPrint("❌ Error fetching archived farms: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFarmById(int farmId) async {
    final db = await database;
    return await db.query('farms', where: 'id = ?', whereArgs: [farmId]);
  }

  Future<int> updateFarm(int id, Map<String, dynamic> updatedData) async {
    try {
      final db = await database;
      return await db.update('farms', updatedData, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error updating farm: $e");
      return -1;
    }
  }

  Future<int> deleteFarm(int id) async {
    try {
      final db = await database;
      return await db.delete('farms', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error deleting farm: $e");
      return -1;
    }
  }

  Future<int> insertExpense(Map<String, dynamic> expenseData) async {
    try {
      final db = await database;
      return await db.insert('expenses', expenseData);
    } catch (e) {
      debugPrint("❌ Error inserting expense: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getExpensesByFarm(int farmId) async {
    try {
      final db = await database;
      // Only return expenses that are not archived (is_archived = 0)
      return await db.query(
        'expenses',
        where: 'farm_id = ? AND is_archived = ?',
        whereArgs: [farmId, 0],
      );
    } catch (e) {
      debugPrint("❌ Error fetching expenses: $e");
      return [];
    }
  }

  Future<int> updateExpense(int id, Map<String, dynamic> expenseData) async {
    try {
      final db = await database;
      return await db.update('expenses', expenseData, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error updating expense: $e");
      return -1;
    }
  }

  Future<int> deleteExpense(int id) async {
    try {
      final db = await database;
      return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error deleting expense: $e");
      return -1;
    }
  }

  Future<int> restoreFarm(int id) async {
    try {
      final db = await database;
      return await db.update('farms', {'is_archived': 0}, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error restoring farm: $e");
      return -1;
    }
  }

  Future<int> restoreExpense(int id) async {
    try {
      final db = await database;
      return await db.update('expenses', {'is_archived': 0}, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("❌ Error restoring expense: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getArchivedExpenses() async {
    try {
      final db = await database;
      return await db.query('expenses', where: 'is_archived = ?', whereArgs: [1]);
    } catch (e) {
      debugPrint("❌ Error fetching archived expenses: $e");
      return [];
    }
  }

  Future<int> restoreFarmWithExpenses(int farmId) async {
    try {
      final db = await database;
      int farmResult = await db.update('farms', {'is_archived': 0},
          where: 'id = ?', whereArgs: [farmId]);
      await db.update('expenses', {'is_archived': 0},
          where: 'farm_id = ?', whereArgs: [farmId]);
      return farmResult;
    } catch (e) {
      debugPrint("❌ Error restoring farm with expenses: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getArchivedExpensesWithFarmInfo() async {
    try {
      final db = await database;
      // Join expenses and farms to fetch farm details with each expense.
      return await db.rawQuery('''
        SELECT 
          e.*, 
          f.name as farm_name,
          f.location as farm_location,
          f.crop as farm_crop
        FROM expenses e
        INNER JOIN farms f ON e.farm_id = f.id
        WHERE e.is_archived = ?
      ''', [1]);
    } catch (e) {
      debugPrint("❌ Error fetching archived expenses: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getExpenseSummary() async {
    try {
      final db = await database;
      return await db.rawQuery('''
        SELECT 
          f.id AS farm_id, 
          f.name AS farm_name, 
          SUM(e.amount) AS total 
        FROM expenses e
        JOIN farms f ON e.farm_id = f.id
        WHERE e.is_archived = 0
        GROUP BY f.id
        ORDER BY total DESC
      ''');
    } catch (e) {
      debugPrint("❌ Error fetching expense summary: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDayWiseExpenses() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        f.name AS farm_name,
        e.date, 
        SUM(e.amount) AS total 
      FROM expenses e
      JOIN farms f ON e.farm_id = f.id
      WHERE e.is_archived = 0
      GROUP BY e.date, f.name
      ORDER BY e.date DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getDayWiseExpensesForFarm(int farmId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        date, 
        SUM(amount) AS total,
        GROUP_CONCAT(category, ',') AS categories
      FROM expenses
      WHERE farm_id = ? AND is_archived = 0
      GROUP BY date
      ORDER BY date DESC
    ''', [farmId]);
  }

  Future<List<Map<String, dynamic>>> getMonthWiseExpenses() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', date) AS month, 
        SUM(amount) AS total 
      FROM expenses
      WHERE is_archived = 0
      GROUP BY month
      ORDER BY month DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getYearWiseExpenses() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        strftime('%Y', date) AS year, 
        SUM(amount) AS total 
      FROM expenses
      WHERE is_archived = 0
      GROUP BY year
      ORDER BY year DESC
    ''');
  }

  Future<void> insertMultipleExpenses(List<Map<String, dynamic>> expensesList) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      for (var expense in expensesList) {
        batch.insert('expenses', expense);
      }
      await batch.commit();
      debugPrint("✅ Batch expenses inserted successfully.");
    } catch (e) {
      debugPrint("❌ Error inserting multiple expenses: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFarmExpenses(int farmId) async {
    final db = await database;
    return await db.query(
      'expenses',
      where: 'farm_id = ?',
      whereArgs: [farmId],
      orderBy: 'date ASC',
    );
  }

}
