import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new product
  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _firestore.collection('products').add(productData);
  }

  // Get all products
  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }

  // Get products by category
  Stream<QuerySnapshot> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }
}