import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> _productDataFuture;
  late Future<Map<String, dynamic>> _salesDataFuture;

  @override
  void initState() {
    super.initState();
    _productDataFuture = getAllProductData();
    _salesDataFuture = getAllSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productDataFuture,
        builder: (context, productSnapshot) {
          if (productSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (productSnapshot.hasError) {
            return Center(
              child: Text('Error: ${productSnapshot.error}'),
            );
          } else {
            final productData = productSnapshot.data!;
            return FutureBuilder<Map<String, dynamic>>(
              future: _salesDataFuture,
              builder: (context, salesSnapshot) {
                if (salesSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (salesSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${salesSnapshot.error}'),
                  );
                } else {
                  final salesData = salesSnapshot.data!;
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      _buildInfoCard(
                        title: 'Product Items',
                        subtitle: 'Quantity: ${productData['total_quantity'].toString()}',
                        trailing: 'Total: ₱${productData['total_value'].toString()}',
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Sales',
                        subtitle: 'Total Sales: ${salesData['total_sales'].toString()}',
                        trailing: 'Total Value: ₱${salesData['total_sales_value'].toString()}',
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Card(
      color: Colors.black,
      child: ListTile(
        leading: Icon(
          Icons.circle,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getAllProductData() async {
    // String url = "http://localhost/flutterproject/api/dashboardproducts.php";
     String url = "https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/dashboardproducts.php";
    final Map<String, dynamic> queryParams = {};

    try {
      http.Response response = await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200 && response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch product data');
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception('Failed to fetch product data');
    }
  }

  Future<Map<String, dynamic>> getAllSalesData() async {
    // String url = "http://localhost/flutterproject/api/dashboardsales.php";

    String url = "https://e09a-2001-fd8-f298-ae4-f861-6f54-d23f-3bf3.ngrok-free.app/flutterproject/api/dashboardsales.php";
    
    final Map<String, dynamic> queryParams = {};

    try {
      http.Response response = await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200 && response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch sales data');
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception('Failed to fetch sales data');
    }
  }
}
