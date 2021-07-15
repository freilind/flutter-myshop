import 'dart:convert';
import 'package:flutter/material.dart';
import './cart_provider.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<CarItemProvider> products;
  final DateTime dateTime;

  Order({Key? key, required this.id, required this.amount, required this.products, required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  final _pathOrders = '';
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final _url = Uri.parse(_pathOrders);
    final response = await http.get(_url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    /*if (extractedData == null) {
      return;
    }*/
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
    final _url = Uri.parse(_pathOrders);
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
    } on Exception catch (_) {
      
    } 
  }
}