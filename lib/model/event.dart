import 'package:flutter_event_app/database/database_provider.dart';

class Event {
  String name;
  String description;
  String dateTime;
  String address;
  List<String> photosUrl = new List();
  String lat, long;

  Event();

  Event.withValue(this.name, this.description, this.dateTime, this.address,
      this.lat, this.long);

  Event.fromMap(Map<String, dynamic> map) {
    name = map[DatabaseProvider.EVENT_NAME];
    address = map[DatabaseProvider.ADDRESS];
    dateTime = map[DatabaseProvider.DATE];
    lat = map[DatabaseProvider.LAT];
    long = map[DatabaseProvider.LONG];
    description = map[DatabaseProvider.DESCRIPTION];
  }

  Event.fromMapName(Map<String, dynamic> map) {
    name = map[DatabaseProvider.EVENT_NAME];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.EVENT_NAME: name,
      DatabaseProvider.ADDRESS: address,
      DatabaseProvider.DATE: dateTime,
      DatabaseProvider.DESCRIPTION: description,
      DatabaseProvider.LAT: lat,
      DatabaseProvider.LONG: long,
    };
    return map;
  }

  Map<String, dynamic> imageToMap(path, name) {
    var map = <String, dynamic>{
      DatabaseProvider.IMAGE_PATH: path,
      DatabaseProvider.EVENT_NAME: name,
    };
    return map;
  }

  insertIntoDb() {
    for (int i = 0; i < photosUrl.length; i++) {
      DatabaseProvider.db.insertImage(photosUrl[i], name);
    }
    DatabaseProvider.db.insert(
        Event.withValue(name, description, dateTime, address, lat, long));
  }
}
