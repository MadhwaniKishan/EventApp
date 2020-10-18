import 'package:flutter/material.dart';
import 'package:flutter_event_app/model/addPhotos.dart';
import 'package:flutter_event_app/provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'model/event.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  FocusNode _nameFocusNode = new FocusNode();

  FocusNode _descriptionFocusNode = new FocusNode();

  FocusNode _addressFocusNode = new FocusNode();

  final nameController = TextEditingController(text: "");

  final descriptionController = TextEditingController(text: "");

  final addressController = TextEditingController(text: "");

  String dateTime;

  @override
  void initState() {
    // TODO: implement initState
    dateTime = getParsedDate(DateTime.now().toIso8601String());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        backgroundColor: Colors.green[700],
      ),
      body: GestureDetector(
        onTap: _clearFocus,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name: ',
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    maxLines: 1,
                    focusNode: _nameFocusNode,
                    enableInteractiveSelection: true,
                    scrollPadding: EdgeInsets.all(10),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    controller: nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Description: ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextField(
                  maxLines: 5,
                  focusNode: _descriptionFocusNode,
                  enableInteractiveSelection: true,
                  scrollPadding: EdgeInsets.all(10),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                  ),
                  controller: descriptionController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Address: ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextField(
                  maxLines: 5,
                  focusNode: _addressFocusNode,
                  enableInteractiveSelection: true,
                  scrollPadding: EdgeInsets.all(10),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                  ),
                  controller: addressController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Date and Time: ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2022))
                        .then((date) {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((time) {
                        setState(() {
                          dateTime = getParsedDate(date
                              .add(Duration(
                                  hours: time.hour, minutes: time.minute))
                              .toIso8601String());
                        });
                      });
                    })
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(dateTime),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colors.white,
                        onPressed: () => goNext(context),
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 24),
                        ),
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _clearFocus() {
    _nameFocusNode.unfocus();
    _descriptionFocusNode.unfocus();
    _addressFocusNode.unfocus();
  }

  String getParsedDate(date) {
    DateTime parseDt = DateTime.parse(date).toLocal();
    var formatter = new DateFormat("MMMM d, y   -   hh:mm a");
    String formatted = formatter.format(parseDt);
    return formatted;
  }

  goNext(context) {

    final appState = Provider.of<ProviderClass>(context);
    appState.name = nameController.text;
    appState.description = descriptionController.text;
    appState.address = addressController.text;
    appState.dateTime = dateTime;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPhotos()));
  }
}
