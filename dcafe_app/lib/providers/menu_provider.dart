import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/poster_api_service.dart';

class MenuProvider with ChangeNotifier {
  final PosterApiService _apiService;

  MenuProvider(this._apiService);

  List<Category> _categories = [];
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategoryId;

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategoryId => _selectedCategoryId;

  /// Get filtered products based on selected category
  List<Product> get filteredProducts {
    if (_selectedCategoryId == null || _selectedCategoryId == 'all') {
      return _products.where((p) => p.isVisible && p.isAvailable).toList();
    }
    return _products
        .where((p) =>
            p.categoryId == _selectedCategoryId &&
            p.isVisible &&
            p.isAvailable)
        .toList();
  }

  /// Load categories and products from Poster API
  Future<void> loadMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load categories and products in parallel
      final results = await Future.wait([
        _apiService.getCategories(),
        _apiService.getProducts(),
      ]);

      _categories = (results[0] as List<Category>)
          .where((c) => c.isVisible)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      _products = (results[1] as List<Product>);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a category to filter products
  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  /// Refresh menu data
  Future<void> refresh() async {
    await loadMenu();
  }
}
