import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  Future<void> fetchProducts() async {
    // Implement your actual product fetching logic here
    // For now, we'll just return the local list
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
    // Here you would typically also save to your backend/database
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index >= 0) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
    // Here you would typically also update in your backend/database
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
    // Here you would typically also delete from your backend/database
  }

  List<Product> getProductsByCategory(String category) {
    if (category == 'All') return _products;
    return _products.where((p) => p.category == category).toList();
  }
}