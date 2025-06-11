// cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
