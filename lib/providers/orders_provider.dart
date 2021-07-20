import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:store_app/providers/base_provider.dart';
import './cart_provider.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<CarItemProvider> products;
  final DateTime dateTime;

  Order({Key? key, required this.id, required this.amount, required this.products, required this.dateTime});
}

class OrdersProvider extends BaseProvider with ChangeNotifier {
  final _pathOrders = 'orders';
  final _pathExtension = '.json';
  final _pathAuth = '?auth=';
  List<Order> _orders = [];
  String authToken = '';
  String userId = '';


  set auth(token) {
    this.authToken = token;
    notifyListeners();
  }

  set orders(orders) {
    this._orders = orders;
    notifyListeners();
  }
 
  set userIdd(id) {
    this.userId = id;
    notifyListeners();
  }

  String get auth{
    return this.authToken;
  }
 
  String get userIdd {
    return this.userId;
  }

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final _url = Uri.parse('$pathBase/$_pathOrders/$userId$_pathExtension$_pathAuth$authToken');
    final response = await http.get(_url);
    final List<Order> loadedOrders = [];
    final  extractedData = await json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        Order(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CarItemProvider(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    )
              )
              .toList(),
        )
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CarItemProvider> cartProducts, double total) async {
    final _url = Uri.parse('$pathBase/$_pathOrders/$userId$_pathExtension$_pathAuth$authToken');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        _url, 
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          }).toList()
        })
      );

      _orders.insert(0, Order(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts));
      notifyListeners();
    } on Exception catch (error) {
      print(error);
    } 
  }
}