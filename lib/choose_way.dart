import 'dart:io';

import 'package:final_project/add_product_page.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PictureTranslator extends StatefulWidget {
  const PictureTranslator({Key? key}) : super(key: key);

  @override
  _PictureTranslatorState createState() => _PictureTranslatorState();
}

class _PictureTranslatorState extends State<PictureTranslator> {
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 120, bottom: 110, left: 5),
                  child: Image.asset(
                    "assets/images/photoMode.png",
                  ),
                ),
                const Text(
                  "Take a photo with your phone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: Constants.OPEN_SANS,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                )
              ],
            )),
            Container(
              margin: const EdgeInsets.only(bottom: 70),
              child: VerticalDivider(
                color: Colors.grey[350],
                thickness: 2,
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 95, bottom: 102, right: 5),
                  child: Image.asset(
                    "assets/images/phoneGallery.png",
                  ),
                ),
                const Text(
                  "Pick photo from your gallery.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: Constants.OPEN_SANS,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                )
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: const Alignment(1, 0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () => _getImage(FileMode.CAMERA),
              tooltip: 'Pick Image from camera',
              child: const Icon(Icons.camera_alt),
              heroTag: null,
            ),

            // ギャラリー（ファイル）検索起動ボタン
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () => _getImage(FileMode.GALLERY),
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.folder_open),
              heroTag: null,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future _getImage(FileMode fileMode) async {
    // null safety対応のため、lateで宣言
    late final PickedFile? _pickedFile;

    // image_pickerの機能で、カメラからとギャラリーからの2通りの画像取得（パスの取得）を設定
    if (fileMode == FileMode.CAMERA) {
      _pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    } else {
      _pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (_pickedFile != null) {
        _pickedImage = File(_pickedFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AddProduct(path: _pickedImage!.path);
            },
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }
}

enum FileMode {
  CAMERA,
  GALLERY,
}
