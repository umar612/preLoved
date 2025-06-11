import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<QuerySnapshot> get productsStream {
    return _firestoreService.getProducts();
  }

  Stream<QuerySnapshot> getProductsByCategory(String category) {
    return _firestoreService.getProductsByCategory(category);
  }
}