import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:store_app/models/http_exception.dart';
import 'package:store_app/providers/base_provider.dart';
import 'package:store_app/providers/product.dart';

class ProductsProvider extends BaseProvider with ChangeNotifier{
  final _pathProducts = 'products';
  final _pathUserFavorites = 'userFavorites';
  final _pathExtension = '.json';
  final _pathAuth = 'auth=';
  var _showFavoritesOnly = false;
  String authToken = '';
  String userId = '';
  List<Product> _items = [];

  set auth(token) {
    this.authToken = token;
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

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((product) => product.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {    
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse('$pathBase/$_pathProducts$_pathExtension?$_pathAuth$authToken$filterString');
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData.isEmpty) {
        return;
      }
      final urlFavorites = Uri.parse('$pathBase/$_pathUserFavorites/$userId/$_pathExtension?$_pathAuth$authToken');
      final favoriteResponse = await http.get(urlFavorites);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavorite: favoriteData == null ? false : favoriteData[productId] ?? false,
          imageUrl: productData['imageUrl']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } on Exception catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final _url = Uri.parse('$pathBase/$_pathProducts$_pathExtension?$_pathAuth$authToken');
    try {
      final response = await http.post(_url, body : json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId
      }));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        final _url = Uri.parse('$pathBase/$_pathProducts/$id$_pathExtension?$_pathAuth$authToken');
        await http.patch(
          _url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        print('prodIndex: $prodIndex');
      }
    }catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final _url = Uri.parse('$pathBase/$_pathProducts/$id$_pathExtension?$_pathAuth$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(_url);
    if (response.statusCode > 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
