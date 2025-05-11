import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Key for SharedPreferences to store favorite article IDs
  static const _favoriteKey = 'favorite_articles';

  // List to hold favorite article IDs
  Set<int> _favoriteIds = {};

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _articles = data.map((e) => Article.fromJson(e)).toList();
        _filteredArticles = _articles;
      } else {
        _error = 'Failed to load articles';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles.where((article) =>
      article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.body.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  // Load favorite articles from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoriteKey) ?? [];
    _favoriteIds = favoriteIds.map((id) => int.parse(id)).toSet();
    notifyListeners();
  }

  // Save favorite articles to SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favoriteIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoriteKey, favoriteIds);
  }

  // Check if an article is a favorite
  bool isFavorite(int id) => _favoriteIds.contains(id);

  // Toggle favorite status and save to SharedPreferences
  void toggleFavorite(int id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await saveFavorites(); // Save the updated favorites to SharedPreferences
    notifyListeners();
  }

  List<Article> get favorites =>
      _articles.where((a) => _favoriteIds.contains(a.id)).toList();
}
