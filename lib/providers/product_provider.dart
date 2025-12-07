import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/entrepot_product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Product> _products = [];
  List<EntrepotProduct> _entrepotProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<EntrepotProduct> get entrepotProducts => _entrepotProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts({String? search, int? categoryId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts(
        search: search,
        categoryId: categoryId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadEntrepotProducts({
    int? entrepotId,
    String? search,
    bool? lowStock,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entrepotProducts = await _productService.getEntrepotProducts(
        entrepotId: entrepotId,
        search: search,
        lowStock: lowStock,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      final created = await _productService.createProduct(product);
      _products.add(created);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(int id, Product product) async {
    try {
      final updated = await _productService.updateProduct(id, product);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

