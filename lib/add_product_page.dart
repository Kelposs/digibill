import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Category/category.dart';
import 'package:final_project/Screens/FirstPage/dashboard_page.dart';
import 'package:final_project/chart.dart';
import 'package:final_project/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:lottie/lottie.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late AsyncMemoizer _memoizer;

  String _extractText = '';
  final List<Product> productsToShow = [];
  late int _count;
  late String _result;
  late List<Map<String, dynamic>> _values;
  late List<Map<String, dynamic>> _names;
  late List<Map<String, dynamic>> _valuesCat;
  late String _selected;
  late String _setDate;
  late int fullPrice;

  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("y/M/d").format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fullPrice = 0;
    _memoizer = AsyncMemoizer();
    _result = "";
    _count = 0;
    _values = [];
    _names = [];
    _valuesCat = [];
    _selected = "Food";

    _dateController.text = DateFormat("y/M/d").format(DateTime.now());
    _setDate = "";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: extractProducts(widget.path),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: size.height,
            width: size.width,
            color: Colors.green,
            child: Center(
              child: Lottie.asset('assets/images/loading.json'),
            ),
          );
        } else {
          return Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green.shade400),
                  ),
                  onPressed: () {
                    saveData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ChartView();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "SAVE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  )),
            ),
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/wall.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Center(
                      child: Text(
                        "ADD RECEIPT",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Spacer(),
                  //     Icon(
                  //       Icons.help_outline,
                  //       size: 40,
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 19),
                        child: const Text(
                          "¥",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(
                          fullPrice.toString(),
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.calendar_today),

                      // Text(
                      //   'DATE',
                      //   style: TextStyle(
                      //       fontStyle: FontStyle.italic,
                      //       fontSize: 30,
                      //       fontWeight: FontWeight.w600,
                      //       letterSpacing: 0.5),
                      // ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: 270,
                          alignment: Alignment.center,
                          child: TextFormField(
                            style: const TextStyle(fontSize: 30),
                            textAlign: TextAlign.left,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onSaved: (String? val) {
                              _setDate = val!;
                            },
                            decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: const Text(
                          'Item list',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _count++;
                              _valuesCat
                                  .add({"id": (_count - 1), "value": "Food"});
                              Product newProduct = Product();
                              newProduct.category = "Food";
                              newProduct.name = "";
                              newProduct.price = "0";
                              productsToShow.add(newProduct);
                            });
                          },
                          child: const Text("+ add Product"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(color: Colors.red))))
                          // fill in required params
                          )
                    ],
                  ),
                  const Divider(
                    thickness: 0.8,
                  ),
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        return _row(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
          //   body: Container(
          //     // height: 90,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: Icon(Icons.add),
          //     style: ElevatedButton.styleFrom(
          //       shape: CircleBorder(),
          //       padding: EdgeInsets.all(24),
          //     ),
          //   ),
          // ),
          // );
          // return Scaffold(
          //   body: DropdownSearch<String>(
          //       mode: Mode.MENU,
          //       showSelectedItems: true,
          //       items: const [
          //         "Food",
          //         "Electronics",
          //         "Health",
          //         'Clothes',
          //         "Books",
          //         "Hobby",
          //         "Entertainment",
          //         "Transport",
          //         "Beauty",
          //         "Utilities",
          //         "Interior",
          //         "Other"
          //       ],
          //       label: "Product category",
          //       hint: "choose a category from a list",
          //       // popupItemDisabled: (String s) => s.startsWith('I'),
          //       onChanged: print,
          //       selectedItem: "Food"),
          // );
        }
      },
    );
  }

  _row(int index) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                // height: 50,
                width: 69,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      items: categoriesData.map((mapData) {
                        return DropdownMenuItem(
                            value: mapData["name"],
                            child: Image.asset(
                              mapData["icon"],
                              width: 25,
                            ));
                      }).toList(),
                      value: indexChecker(index),
                      onChanged: (newValue) {
                        setState(() {
                          _onUpdateCat(index, newValue as String);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  initialValue: productsToShow[index].name,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: "Name",
                      contentPadding: EdgeInsets.all(3.0),
                      isDense: true),

                  // initialValue: ,
                  onChanged: (val) {
                    _onUpdate(index, val);
                  },
                ),
              ),
              const SizedBox(width: 30),
              Container(
                width: 100,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  initialValue: productsToShow[index].price.toString(),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: "Price",
                      contentPadding: EdgeInsets.all(3.0),
                      isDense: true),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (val) {
                    _onUpdate2(index, val);
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.8,
        ),
      ],
    );
  }

  String indexChecker(int index) {
    return _valuesCat[
        _valuesCat.indexWhere((element) => element["id"] == index)]["value"];
  }

  void _onUpdateCat(int index, String val) {
    int foundKey = -1;
    for (var map in _valuesCat) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _valuesCat.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {"id": index, "value": val};
    _valuesCat.add(json);
    productsToShow[index].category = val;
    // _values[_values.indexWhere((element) => element["id"] == 1)]["value"]);//musi byc jakis counter i zapisywac to jako counter => value , counter+1 => new value , counter+2 => new new value
  }

  void _onUpdate2(int index, String val) {
    int foundKey = -1;
    for (var map in _values) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {"id": index, "value": val};
    _values.add(json);
    productsToShow[index].price = val;
    var tempPrice = 0;
    for (var i = 0; i < productsToShow.length; i++) {
      try {
        tempPrice += int.parse(productsToShow[i].price);
      } catch (e) {
        continue;
      }
      // tempPrice += int.parse(json[i]);
    }
    setState(() {
      fullPrice = tempPrice;
    });
    // _values[_values.indexWhere((element) => element["id"] == 1)]["value"]);//musi byc jakis counter i zapisywac to jako counter => value , counter+1 => new value , counter+2 => new new value
  }

  void _onUpdate(int index, String val) {
    int foundKey = -1;
    for (var map in _names) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _names.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {"id": index, "value": val};
    _names.add(json);
    productsToShow[index].name = val;
    // _values[_values.indexWhere((element) => element["id"] == 1)]["value"]);//musi byc jakis counter i zapisywac to jako counter => value , counter+1 => new value , counter+2 => new new value
  }

  extractProducts(String path) async {
    return _memoizer.runOnce(() async {
      try {
        _extractText =
            await FlutterTesseractOcr.extractText(path, language: 'jpn')
                .timeout(const Duration(seconds: 10));
      } catch (e) {
        _extractText = "";
      }
      divideTitlePrice(_extractText);
      _count = productsToShow.length;
      for (var i = 0; i < _count; i++) {
        productsToShow[i].category = "Food";
        _valuesCat.add({"id": i, "value": "Food"});
      }
      return _extractText;
    });
  }

  divideTitlePrice(textToConvert) {
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
    // print(list);
    eraseEmptySlot(namePrice);
    eraseTrashFields(namePrice);
    // print(namePrice);
  }

  eraseEmptySlot(namePrice) {
    for (var i = 0; i < namePrice.length; i++) {
      if (namePrice[i].length > 2) {
        namePrice[i].removeAt(0);
      }
    }
  }

  eraseTrashFields(namePrice) {
    // final namePriceLength = namePrice.length;
    // final copy = List.from(namePrice);
    for (var i = 0; i < namePrice.length; i++) {
      if (namePrice[i][0].data.contains("値引") ||
          namePrice[i][0].data.contains("小計") ||
          namePrice[i][0].data.contains("合計") ||
          namePrice[i][0].data.contains("お釣り") ||
          namePrice[i][0].data.contains("お預り")) {
        namePrice.removeAt(i);
        i--;
      } else {
        try {
          Product addProduct = Product();
          addProduct.name = namePrice[i][0].data;
          addProduct.price =
              namePrice[i][1].data.replaceAll(RegExp(r'[^\w\s]+'), '');
          fullPrice += int.parse(addProduct.price);
          productsToShow.add(addProduct);
        } catch (e) {
          continue;
        }
      }
    }
  }

  void saveData() async {
    //ustawienia ogolne

    // var collection =
    //     FirebaseFirestore.instance.collection('Names').doc("$loginUser");
    var collection =
        FirebaseFirestore.instance.collection('Names').doc(loginUser?.email);
    var hashcode = hashCode;
    var noSlashes = _dateController.text.replaceAll("/", "&");

    //dodaj Date

    var date = collection.collection("Dates").doc("$hashcode#$noSlashes");

    final Map<String, int> _catPrice = {};

    for (var i = 0; i < productsToShow.length; i++) {
      //dodajemy wszystkie ceny
      if (!_catPrice.containsKey(productsToShow[i].category)) {
        try {
          _catPrice[productsToShow[i].category] =
              int.parse(productsToShow[i].price);
        } catch (e) {
          continue;
        }
      } else {
        try {
          _catPrice[productsToShow[i].category] =
              _catPrice[productsToShow[i].category]! +
                  (int.parse(productsToShow[i].price));
        } catch (e) {
          continue;
        }
      }
    }
    final listName = [];
    _catPrice.forEach((k, v) => listName.add(k));
    for (var i = 0; i < listName.length; i++) {
      date.set({"${listName[i]}": "${_catPrice[listName[i]]}"},
          SetOptions(merge: true));
      //product
      var product = collection.collection("Products").doc("${listName[i]}");
      product.set({"$hashcode#$noSlashes": "${_catPrice[listName[i]]}"},
          SetOptions(merge: true));
    }
  }
}
