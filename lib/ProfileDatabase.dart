import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class mydatabaseclass {
  Database? mydb;

  Future<Database?> mydbcheck() async {
    if (mydb == null) {
      mydb = await initiatedatabase();
      return mydb;
    } else {
      return mydb;
    }
  }

  int Version = 1;
  initiatedatabase() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase.db');
    Database mydatabase1 = await openDatabase(
      databasepath,
      version: Version,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS TABLE1 (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        FIRST_NAME TEXT NOT NULL,
        SECOND_NAME TEXT NOT NULL,
        EMAIL TEXT NOT NULL)
      ''');
        print("Database has been created");
      },
    );
    return mydatabase1;
  }

  checking() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase.db');
    await databaseExists(databasepath) ? print("it exists") : print("hardluck");
  }

  reseting() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase.db');
    await deleteDatabase(databasepath);
  }

  reading(String sql) async {
    Database? somevariable = await mydbcheck();
    var response = await somevariable!.rawQuery(sql);
    return response;
  }

  writing(String sql) async {
    Database? somevariable = await mydbcheck();
    var response = await somevariable!.rawInsert(sql);
    return response;
  }

  deleting(String sql) async {
    Database? somevariable = await mydbcheck();
    var response = await somevariable!.rawDelete(sql);
    return response;
  }

  updating(String sql) async {
    Database? somevariable = await mydbcheck();
    var response = await somevariable!.rawUpdate(sql);
    return response;
  }

  Future<Map<String, dynamic>> fetchUserProfileByEmail(String email) async {
    try {
      String sql = 'SELECT * FROM TABLE1 WHERE EMAIL = "$email"';
      List<Map<String, dynamic>> result = await reading(sql);

      if (result.isNotEmpty) {
        return {
          'riderName': result[0]['FIRST_NAME'] + ' ' + result[0]['SECOND_NAME'],
          'riderFirstName': result[0]['FIRST_NAME'],
          'riderLastName': result[0]['SECOND_NAME'],
          'riderEmail': result[0]['EMAIL'],
        };
      } else {
        throw ('No user profile data found for $email');
      }
    } catch (e) {
      throw ('Error fetching user profile data: $e');
    }
  }

  Future<int> insertUser(String firstName, String lastName, String email) async {
    try {
      Database? db = await mydbcheck(); // Wait for the Future to complete
      if (db != null) {
        String sql = 'INSERT INTO TABLE1 (FIRST_NAME, SECOND_NAME, EMAIL) VALUES (?, ?, ?)';
        int result = await db.rawInsert(sql, [firstName, lastName, email]);
        return result;
      } else {
        throw ('Error: Database is null');
      }
    } catch (e) {
      throw ('Error inserting user data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserFullNameByEmail(String email) async {
    try {
      String sql = 'SELECT FIRST_NAME, SECOND_NAME FROM TABLE1 WHERE EMAIL = "$email"';
      List<Map<String, dynamic>> result = await reading(sql);

      if (result.isNotEmpty) {
        return {
          'fullName': result[0]['FIRST_NAME'] + ' ' + result[0]['SECOND_NAME'],
        };
      } else {
        throw ('No user profile data found for $email');
      }
    } catch (e) {
      throw ('Error fetching user profile data: $e');
    }
  }

}
