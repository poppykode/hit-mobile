import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function _selectedImage;
    ImageInput(this._selectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  File _image;

  Future<void> _takePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    if (image == null) {
      return;
    }
        // to get the directory which are allowed for any file storage by the platform
    final appDir = await syspaths.getTemporaryDirectory();
        //to ge the file name of the file in temporary storage
    final fileName = path.basename(image.path);
    //image location
    final savedImage = await image.copy('${appDir.path}/$fileName');
    print(savedImage);
    widget._selectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
          height: deviceSize.size.height *0.15,
          alignment: Alignment.center,
          child: _image != null? Image.file(_image):Center(child: Text('Take a Profile Picture'),),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).accentColor)),
        ),
            RaisedButton.icon(
              icon: Icon(Icons.add_a_photo),
              label: Text('Open Camera'),
              onPressed:_takePicture,
            )
    
          ],
        ),
        SizedBox(
          height: deviceSize.size.height * 0.02,
        ),
      
      ],
    );
  }
}
