import 'package:flutter/foundation.dart';

class CarItemProvider {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CarItemProvider({required this.id, required this.title, required this.price, required this.quantity});
}

class CartProvider with ChangeNotifier {
  Map<String, CarItemProvider> _items = {};
  Map<String, CarItemProvider> get items {
    return {..._items};
  }

  int get itemCount {
    int count = 0;
    _items.forEach((key, value) => count += value.quantity);
    return count;
  }

  double get totalAmount {
    var _total = 0.0;
    _items.forEach((key, cartItem) { 
      _total += cartItem.quantity * cartItem.price;
    });
    return _total;
  }

  void addItem(String productId, double price, String title,) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CarItemProvider(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1)
        );
    } else {
      _items.putIfAbsent(
          productId,
          () => CarItemProvider(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,)
        );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity  > 1) {
      _items.update(
          productId,
          (existingCartItem) => CarItemProvider(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1)
        );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

}
