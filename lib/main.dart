import 'package:flutter/material.dart';
import 'package:flutter_event_app/addEvent.dart';
import 'package:flutter_event_app/provider/provider.dart';
import 'package:provider/provider.dart';

import 'database/database_provider.dart';
import 'detialPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => ProviderClass(),
      child: MaterialApp(
        title: 'Event App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> events = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseProvider.db.getEvents().then((eventList) => {
          if (eventList.length > 0) {events = eventList}
        });
  }

  refreshData() {
    setState(() {
      DatabaseProvider.db.getEvents().then((eventList) => {
            if (eventList != null) {events = eventList}
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(widget.title),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.refresh),
            onTap: refreshData,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return DetailPage(events[index]);
                  }),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(events[index]),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        tooltip: 'Add Event',
        backgroundColor: Colors.green[700],
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  _addNewEvent() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddEvent()));
  }
}
