import 'package:flutter_event_app/model/event.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String EVENT_IMAGES = "images";
  static const String IMAGE_PATH = "path";

  static const String EVENT = "event";
  static const String COLUMN_ID = "id";
  static const String EVENT_NAME = "name";
  static const String DESCRIPTION = "description";
  static const String DATE = "date";
  static const String ADDRESS = "address";
  static const String LAT = "lat";
  static const String LONG = "long";

  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, "eventsDB.db"),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          "Create Table $EVENT_IMAGES ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$IMAGE_PATH TEXT,"
          "$EVENT_NAME TEXT"
          ")",
        );

        await database.execute(
          "Create Table $EVENT ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$EVENT_NAME TEXT,"
          "$DESCRIPTION TEXT,"
          "$DATE TEXT,"
          "$ADDRESS TEXT,"
          "$LAT TEXT,"
          "$LONG TEXT"
          ")",
        );
      },
    );
  }

  Future<List<String>> getEvents() async {
    final db = await database;

    var events = await db.query(EVENT, columns: [EVENT_NAME]);
    List<String> eventList = new List();
    events.forEach((event) {
      Event eventGot = Event.fromMapName(event);
      eventList.add(eventGot.name);
    });
    return eventList;
  }

  Future<Event> getEvent(String name) async {
    final db = await database;

    var eventDetail = await db.query(EVENT,
        columns: [COLUMN_ID, EVENT_NAME, DESCRIPTION, DATE, ADDRESS, LAT, LONG],
        where: '$EVENT_NAME = ?',
        whereArgs: ['$name'],
        limit: 1);

    List<String> imageUrls = new List();
    var images = await db.query(EVENT_IMAGES,
        columns: [IMAGE_PATH], where: '$EVENT_NAME = ?', whereArgs: ['$name']);
    images.forEach((element) {
      imageUrls.add(element[DatabaseProvider.IMAGE_PATH]);
    });

    Event event = Event.fromMap(eventDetail[0]);
    event.photosUrl = imageUrls;
    return event;
  }

  Future<Event> insert(Event event) async {
    final db = await database;
    await db.insert(EVENT, event.toMap());
    return event;
  }

  insertImage(String path, String name) async {
    Event event = new Event();
    final db = await database;
    await db.insert(EVENT_IMAGES, event.imageToMap(path, name));
  }

  Future<int> deleteEvent(eventName) async {
    final db = await database;
    await db.delete(EVENT_IMAGES,
        where: '$EVENT_NAME = ?', whereArgs: ['$eventName']);
    final res = await db
        .delete(EVENT, where: '$EVENT_NAME = ?', whereArgs: ['$eventName']);
    return res;
  }

  Future<int> deleteAllData() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $EVENT');
    return res;
  }
}
