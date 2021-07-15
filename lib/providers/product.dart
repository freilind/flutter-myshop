import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final _pathProducts = '';
  final _pathExtension = '.json';
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

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final _url = Uri.parse('$_pathProducts/$id$_pathExtension');
    try {
      final response = await http.patch(
        _url, 
        body: json.encode({
          'isFavorite': isFavorite
        })
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } on Exception catch (_) {
      _setFavoriteValue(oldStatus);
    }
  }
}
