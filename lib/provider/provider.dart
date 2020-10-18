import 'package:flutter/foundation.dart';
import 'package:flutter_event_app/model/event.dart';

class ProviderClass with ChangeNotifier {
  String _name;
  String _description;
  String _dateTime;
  String _address;
  List<String> _photosUrl = new List();
  String _lat, _long;
  Event _event;

  Event get event => _event;

  set event(Event value) {
    _event = value;
    notifyListeners();
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  get long => _long;

  set long(value) {
    _long = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  List<String> get photosUrl => _photosUrl;

  set photosUrl(List<String> value) {
    _photosUrl = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }
}
