import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notification_model.dart';

class NotificationDatabaseHelper {
  static Database? _database;

  // Add an explicit initialization method
  static Future<void> initDatabase() async {
    if (_database != null) return;

    String path = join(await getDatabasesPath(), 'notifications_v1.db');
    _database = await openDatabase(
      path,
      version: 1, // Starting fresh with version 1
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE notifications(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            timestamp TEXT,
            isRead INTEGER,
            navigationTarget TEXT,
            navigationId TEXT,
            imageUrl TEXT,
            notificationType TEXT,
            notificationAction TEXT,
            isCalendar TEXT,
            location TEXT,
            startDate TEXT,
            endDate TEXT,
            userId TEXT,
            priority TEXT,
            popupDataActionId TEXT,
            popupDataActionType TEXT,
            popupDataRemark TEXT,
            popupAdditionalData TEXT
          )''',
        );
      },
    );
    print('✅ Database initialized successfully');
  }

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    await initDatabase();
    return _database!;
  }

  static Future<int> insertNotification(AppNotification notification) async {
    try {
      final db = await getDatabase();

      // Convert notification to map
      final Map<String, dynamic> notificationMap = notification.toMap();

      print('Inserting notification with ID: ${notification.id}');
      print('Data: $notificationMap');

      return await db.insert(
        'notifications',
        notificationMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stack) {
      print('❌ Error inserting notification: $e');
      print('Stack trace: $stack');
      return -1;
    }
  }

  // Fetch all notifications
  static Future<List<AppNotification>> getAllNotifications() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'timestamp DESC',
    );

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
