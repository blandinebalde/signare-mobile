import '../models/product_model.dart';
import '../models/entrepot_product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<List<Product>> getProducts({
    int? page,
    int? size,
    String? search,
    int? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (size != null) queryParams['size'] = size;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (categoryId != null) queryParams['categoryId'] = categoryId;

      final response = await _apiService.get('/products', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('content')) {
          final List<dynamic> productsJson = data['content'] as List<dynamic>;
          return productsJson.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    try {
      final response = await _apiService.get('/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit: $e');
    }
  }

  // Get entrepot products
  Future<List<EntrepotProduct>> getEntrepotProducts({
    int? entrepotId,
    int? page,
    int? size,
    String? search,
    bool? lowStock,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;
      if (page != null) queryParams['page'] = page;
      if (size != null) queryParams['size'] = size;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (lowStock != null) queryParams['lowStock'] = lowStock;

      final response = await _apiService.get('/entrepot-products', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('content')) {
          final List<dynamic> productsJson = data['content'] as List<dynamic>;
          return productsJson.map((json) => EntrepotProduct.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => EntrepotProduct.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits: $e');
    }
  }

  // Create product
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _apiService.post('/products', data: product.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la création du produit');
    } catch (e) {
      throw Exception('Erreur lors de la création du produit: $e');
    }
  }

  // Update product
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _apiService.put('/products/$id', data: product.toJson());
      if (response.statusCode == 200) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la mise à jour du produit');
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du produit: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.delete('/products/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression du produit: $e');
    }
  }
}

