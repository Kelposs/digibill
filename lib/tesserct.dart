import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = '';
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Tesseract OCR'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () => _getImage(FileMode.CAMERA),
            tooltip: 'Pick Image from camera',
            child: const Icon(Icons.camera_alt),
            heroTag: null,
          ),

          // ギャラリー（ファイル）検索起動ボタン
          FloatingActionButton(
            onPressed: () => _getImage(FileMode.GALLERY),
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.folder_open),
            heroTag: null,
          ),
        ],
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: FileImage(_pickedImage!),
                        fit: BoxFit.fill,
                      )),
                ),

//               onPressed: () async {
//                 setState(() {
//                   _scanning = true;
//                 });
//                 // final pickedFile =
//                 //     await ImagePicker().getImage(source: ImageSource.gallery);
//                 // setState(() {
//                 //   _pickedImage = File(pickedFile!.path);
//                 // });
//                 // _pickedImage = (await ImagePicker()
//                 //     .getImage(source: ImageSource.gallery)) as File;
//                 _getImage(FileMode fileMode);
//                 _extractText = await FlutterTesseractOcr.extractText(
//                     _pickedImage!.path,
//                     language: 'jpn');
//                 divideTitlePrice(_extractText);
// // split the text into an array
//                 setState(() {
//                   _scanning = false;
//                 });
//               },
          const SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _getImage(FileMode fileMode) async {
    // null safety対応のため、lateで宣言
    late final PickedFile? _pickedFile;
    setState(() {
      _scanning = true;
    });
    // image_pickerの機能で、カメラからとギャラリーからの2通りの画像取得（パスの取得）を設定
    if (fileMode == FileMode.CAMERA) {
      _pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    } else {
      _pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (_pickedFile != null) {
        _pickedImage = File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    _extractText = await FlutterTesseractOcr.extractText(_pickedImage!.path,
        language: 'jpn');
    divideTitlePrice(_extractText);
// split the text into an array
    setState(() {
      _scanning = false;
    });
  }
}

void divideTitlePrice(textToConvert) {
  List<dynamic> list =
      textToConvert.split('\n'); // split the text into an array
  // put the text inside a widget
  var namePrice = [];
  for (var i = 0; i < list.length; i++) {
    list[i] = list[i].replaceAll(" ", "");
    if (list[i].contains("¥")) {
      namePrice.add(list[i]
          .split("¥")
          .map((String text) => Text(text)) // put the text inside a widget
          .toList());
    }
  }

  print(list);
  print(namePrice);
}

enum FileMode {
  CAMERA,
  GALLERY,
}
