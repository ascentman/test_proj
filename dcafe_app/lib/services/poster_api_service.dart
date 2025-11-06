import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../utils/config.dart';

class PosterApiService {
  final Dio _dio;
  String? _accessToken;

  PosterApiService() : _dio = Dio(BaseOptions(
    baseUrl: AppConfig.posterApiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Set access token for authenticated requests
  /// Get token from: https://joinposter.com/manage/integration
  void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Get all categories from Poster
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(
        AppConfig.categoriesEndpoint,
        queryParameters: {
          'token': _accessToken,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['response'];
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get all products from Poster
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(
        AppConfig.menuEndpoint,
        queryParameters: {
          'token': _accessToken,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['response'];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get products filtered by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final allProducts = await getProducts();
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  /// Create incoming order in Poster
  /// This will be called after successful payment
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalAmount,
    String? customerName,
    String? customerPhone,
    String? comment,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.createOrderEndpoint,
        queryParameters: {
          'token': _accessToken,
        },
        data: {
          'spot_id': '1', // Default spot, configure as needed
          'phone': customerPhone ?? '',
          'client_name': customerName ?? 'Mobile App Order',
          'products': products,
          'comment': comment ?? 'Order from D.Cafe mobile app',
        },
      );

      if (response.statusCode == 200) {
        return response.data['response'];
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
