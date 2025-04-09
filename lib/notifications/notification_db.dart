import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notification_model.dart';

class NotificationDatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'notifications.db');
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE notifications(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            timestamp TEXT,
            isRead INTEGER,
            navigationTarget TEXT,
            navigationId TEXT,  -- Added new field
            imageUrl TEXT
          )''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE notifications ADD COLUMN navigationId TEXT;');
        }
      },
    );
    return _database!;
  }

  static Future<int> insertNotification(AppNotification notification) async {
    final db = await getDatabase();
    return await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all notifications
  static Future<List<AppNotification>> getAllNotifications() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'id DESC',
    );

    // Log retrieved data to the console
    // print('Retrieved Notifications from Database:');
    for (var map in maps) {
      // print(map);
    }

    return List.generate(maps.length, (i) {
      return AppNotification.fromMap(maps[i]);
    });
  }

  // Update notification as read
  static Future<void> updateNotificationStatus(String id, bool isRead) async {
    final db = await getDatabase();
    await db.update(
      'notifications',
      {'isRead': isRead ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllNotifications() async {
    final db = await getDatabase();
    await db.delete('notifications');
  }

  static Future<void> deleteNotification(String id) async {
    final db = await getDatabase();
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
