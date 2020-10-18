import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_event_app/addLocation.dart';
import 'package:flutter_event_app/provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddPhotos extends StatefulWidget {
  @override
  _AddPhotosState createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List<String> imageUrls = new List();
  var path2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Photos'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () => loadAssets(),
            child: Text(
              "Add Photos",
              style: TextStyle(fontSize: 24),
            ),
            color: Colors.green,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: buildGridView(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 50,
              width: double.infinity,
              child: FlatButton(
                textColor: Colors.white,
                onPressed: () => _addLocationFromMap(context),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 24),
                ),
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#FF388E3C",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    //path2 = await FlutterAbsolutePath.getAbsolutePath(resultList[0].identifier);
    for (int i = 0; i < resultList.length; i++) {
      FlutterAbsolutePath.getAbsolutePath(resultList[i].identifier)
          .then((value) => imageUrls.add(value));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  _addLocationFromMap(context) {
    final appState = Provider.of<ProviderClass>(context);
    appState.photosUrl = imageUrls;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddLocation()));
  }
}
