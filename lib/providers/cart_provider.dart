import 'package:flutter/foundation.dart';
import 'package:store_app/providers/product.dart';

class CarItemProvider {
  final String id;
  final Product product;
  final int quantity;

  CarItemProvider({required this.id, required this.product, required this.quantity});
}

class CartProvider with ChangeNotifier {
  Map<String, CarItemProvider> _items = {};
  Map<String, CarItemProvider> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var _total = 0.0;
    _items.forEach((key, cartItem) { 
      _total += cartItem.quantity * cartItem.product.price;
    });
    return _total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingCartItem) => CarItemProvider(
              id: existingCartItem.id,
              product: existingCartItem.product,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CarItemProvider(
              id: DateTime.now().toString(), product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

}
