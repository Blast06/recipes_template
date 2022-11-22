import 'dart:core';
import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/database/IngredientsDataProvider.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_NAME = '';
const DATABASE_VERSION = 1;

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = (documentsDirectory.path + "shoppingList.db");
    log('directory path $path}');
    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE_RECIPE($KEY_RECIPE_ID INTEGER PRIMARY KEY,$KEY_RECIPE_TITLE TEXT,$KEY_RECIPE_IMG TEXT,$KEY_RECIPE_CREATE_AT TEXT, $KEY_USER_ID INTEGER)");

    await db
        .execute("CREATE TABLE $TABLE_INGREDIENTS($KEY_INGREDIENT_ID INTEGER PRIMARY KEY, $KEY_RECIPE_ID INTEGER, $KEY_INGREDIENT_TITLE TEXT,$KEY_INGREDIENT_AMOUNT TEXT,$KEY_INGREDIENT_UNIT TEXT, "
            "$KEY_INGREDIENT_STATUS INTEGER DEFAULT 0, $KEY_INGREDIENT_CREATED_AT TEXT)");
  }
}
