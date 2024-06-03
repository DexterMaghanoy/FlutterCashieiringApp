import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutterproject/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class shop extends StatefulWidget {
  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<shop> {
  final TextEditingController _textController = TextEditingController(text: '');
  String data = '';
  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download/qr';
  List<dynamic> _contactsList = [];
  String _msg = "";
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productQuantityController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  List<dynamic> _shopList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List myList = await getProducts();

    setState(() {
      _contactsList = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: getProducts(),
                  builder: (context, snapShot) {
                    switch (snapShot.connectionState) {
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      case ConnectionState.done:
                        if (snapShot.hasError) {
                          return Text("Error: ${snapShot.error}");
                        }
                        return Expanded(child: contactsListView());
                      default:
                        return Text("Error: ${snapShot.error}");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    title: Center(child: Text('Add New Product')),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            RepaintBoundary(
                              key: _qrkey,
                              child: SizedBox(
                                width: 100.0, // Set your desired width
                                height: 100.0, // Set your desired height
                                child: QrImageView(
                                  data: data,
                                  version: QrVersions.auto,
                                  size: 100.0,
                                  gapless: true,
                                  errorStateBuilder: (ctx, err) {
                                    return const Center(
                                      child: Text(
                                        'Something went wrong!!!',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _productCodeController,
                              onChanged: (text) {
                                setState(() {
                                  data = text;
                                });
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'Product Code',
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 146, 20),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _productNameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'Product Name',
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 146, 20),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _productQuantityController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'Product Quantity',
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 146, 20),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _productPriceController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'Product Price',
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 146, 20),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          _captureAndSavePng();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Close'),
                        onPressed: () {
                          _productCodeController.clear();
                          _productNameController.clear();
                          _productQuantityController.clear();
                          _productPriceController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }

  Widget contactsListView() {
    return ListView.builder(
      itemCount: _contactsList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.black,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.circle_fill,
              color: Colors.white, // Set the icon color to white
            ),
            title: Text(
              "   " + _contactsList[index]['prod_name'],
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            subtitle: Text(
              "     Product Code: " +
                  _contactsList[index]['prod_code'].toString() +
                  "\n     Qty: " +
                  _contactsList[index]['prod_quantity'].toString(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "     Price: " + _contactsList[index]['prod_price'].toString(),
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => shop()),
      );
    });
  }

  void saveProduct() async {
    String url = "http://localhost/flutterproject/api/addproducts.php";
    // "https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/addproducts.php";

    final Map<String, dynamic> requestData = {
      "prod_code": _productCodeController.text,
      "prod_name": _productNameController.text,
      "prod_quantity": int.parse(_productQuantityController.text),
      "prod_price": double.parse(_productPriceController.text),
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result["status"] == "success") {
          setState(() {
            _msg = "Product added successfully. ${result["message"]}";
          });
        } else {
          setState(() {
            _msg = "Failed to add product. ${result["message"]}";
          });
        }
      } else {
        print("${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<List> getProducts() async {
    String url = "http://localhost/flutterproject/api/getproducts.php";
    //  "https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/getproducts.php";

    final Map<String, dynamic> queryParams = {};

    try {
      await Future.delayed(Duration(milliseconds: 100));

      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        var contacts = jsonDecode(response.body);
        print("Response Body: $contacts");
        return contacts;
      } else {
        print("Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String fileName = _productCodeController.text.trim();
      while (await File('$externalDir/$fileName.png').exists()) {}

      dirExists = await File(externalDir).exists();
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(content: Text('QR code saved to gallery'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      saveProduct();
      _productCodeController.clear();
      _productNameController.clear();
      _productQuantityController.clear();
      _productPriceController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      print('Error: $e');

      const snackBar = SnackBar(content: Text('Something went wrong!!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
