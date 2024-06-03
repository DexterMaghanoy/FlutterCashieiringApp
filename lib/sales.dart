import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class ProductEntry {
  final int productId; 
  final String productName;
  int quantity;
  double price;
  String totalSales = '';
  double totalAmount = 0.0;

  ProductEntry(this.productId, this.productName, this.quantity, this.price);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntry &&
          runtimeType == other.runtimeType &&
          productName == other.productName;

  @override
  int get hashCode => productName.hashCode;
}

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  void initState() {
    super.initState();
    fetchSalesData(); 
    fetchProducts();
  }

  String _msg = "";
  String totalSales = "";
  ProductEntry? selectedProduct;
  List<ProductEntry> boughtProducts = [];
  List<dynamic> salesData = []; 

  Future<void> fetchSalesData() async {
    final response = await http.get(Uri.parse(
        // 'http://localhost/flutterproject/api/allsales.php'));
        'https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/allsales.php'));
        
        
    if (response.statusCode == 200) {
      setState(() {
        salesData = jsonDecode(response.body); 
      });
    } else {
      print('Failed to fetch sales data: ${response.statusCode}');
    }
  }

Future<List<ProductEntry>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/getproducts.php'));

  if (response.statusCode == 200) {
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    return data.map((item) {
      final int productId = item['prod_id'] as int;
      final String productName = item['prod_name'] as String;
      final int productQuantity = 1; // You might need to adjust this based on your data
      final double productPrice = (item['prod_price'] as int).toDouble(); // Convert integer to double
      
      return ProductEntry(
        productId,
        productName,
        productQuantity,
        productPrice,
      );
    }).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var product in boughtProducts) {
      totalAmount += product.quantity * product.price;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                key: UniqueKey(), 
                builder: (BuildContext context, setState) {
                  return FutureBuilder<List<ProductEntry>>(
                    future: fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return AlertDialog(
                          title: Center(child: Text('Purchase Product')),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16), 

                          content: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, 
                            height: MediaQuery.of(context).size.height *
                                0.6, 

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: DropdownButton<ProductEntry>(
                                          hint: Text(' Select Product'),
                                          value: selectedProduct,
                                          onChanged: (ProductEntry? newValue) {
                                            if (newValue != null &&
                                                !boughtProducts.any((entry) =>
                                                    entry.productName ==
                                                    newValue.productName)) {
                                              setState(() {
                                                selectedProduct = newValue;
                                                boughtProducts.add(newValue);
                                              });
                                            }
                                            setState(() {});
                                          },
                                          items: snapshot.data!
                                              .map<
                                                      DropdownMenuItem<
                                                          ProductEntry>>(
                                                  (ProductEntry value) =>
                                                      DropdownMenuItem<
                                                          ProductEntry>(
                                                        value: value,
                                                        child: Text(
                                                            value.productName),
                                                      ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                        
                                        },
                                        child: Icon(Icons.qr_code_scanner,
                                            size: 48),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                Text('Buy List:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),

                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: boughtProducts
                                            .map(
                                              (product) => Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(product
                                                            .productName),
                                                        Text(
                                                            'Price: \₱${product.price.toStringAsFixed(2)}'), 
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 80,
                                                    child: TextFormField(
                                                      initialValue: product
                                                          .quantity
                                                          .toString(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Qty',
                                                        isDense: true,
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          product.quantity =
                                                              int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                      'Total: \₱${(product.quantity * product.price).toStringAsFixed(2)}'),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        boughtProducts
                                                            .remove(product);
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          10),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                if (boughtProducts
                                    .isNotEmpty) 
                                  SizedBox(height: 10), 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total Amount: \₱${calculateTotalAmount().toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                if (selectedProduct != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Purchase?'),
                                        content: Text(
                                            'Proceed with the purchase or continue editing?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).popUntil(
                                                  (route) => route
                                                      .isFirst); 
                                              addProductsToSales(
                                                  boughtProducts); 
                                              setState(() {
                                                selectedProduct = null;
                                                boughtProducts.clear();
                                              });
                                            },
                                            child: Text('Purchase'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); 
                                     
                                            },
                                            child: Text('Edit'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                              
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please select a product before buying.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Text('Buy'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add_shopping_cart_outlined),
      ),
      body: ListView.builder(
        itemCount: salesData.length,
        itemBuilder: (context, index) {
          final sale = salesData[index];
          return Card(
            margin: EdgeInsets.all(8.0), 
            color:
                Colors.black, 
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), 
            ),
            child: ListTile(
              leading: CircleAvatar(
          
                backgroundColor:
                    Colors.black,
                child: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.white,
                ), // Add icon inside the circle
              ),
              title: Text(
                'Product Name: ${sale['sales_productname']}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity: ${sale['sales_quantity']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Price: ${sale['sales_price']}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              trailing: Text(
                'Total: ${sale['sales_total']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  void addToBuyList(String qrCodeData) {
    setState(() {
 
    });
  }
}

// Function to send product data to API
Future<void> addProductsToSales(List<ProductEntry> products) async {
  final apiUrl =
      Uri.parse(
        // 'http://localhost/flutterproject/api/addsales.php');
        'https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/addsales.php');
  final List<Future<void>> requests = [];

  for (var product in products) {
    final jsonData = {
      'sprod_id': product.productId,
      'sales_quantity': product.quantity,
      'sales_price': product.price,
      'sales_total': product.quantity * product.price,
      'sales_productname': product.productName,
    };

    print('JSON Data: $jsonData'); 

    requests.add(
      http.post(
        apiUrl,
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      ).then((response) {
        if (response.statusCode == 200) {
          print('Product added to sales: ${product.productName}');
        } else {
          print('Failed to add product to sales: ${response.body}');
        }
      }).catchError((error) {
        print('Error adding product to sales: $error');
      }),
    );
  }

  await Future.wait(requests);
}
