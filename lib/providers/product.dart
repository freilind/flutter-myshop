import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/providers/base_provider.dart';

class Product extends BaseProvider with ChangeNotifier {
  final _pathUserFavorites = 'userFavorites';
  final _pathExtension = '.json';
  final _pathAuth = 'auth=';
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final _url = Uri.parse('$pathBase/$_pathUserFavorites/$userId/$id$_pathExtension?$_pathAuth$token');
    try {
      final response = await http.put(
        _url, 
        body: json.encode(isFavorite)
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } on Exception catch (_) {
      _setFavoriteValue(oldStatus);
    }
  }
}
