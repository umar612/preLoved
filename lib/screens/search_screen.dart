import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart'; // Import the single Product model

class SearchScreen extends StatelessWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final cartProvider = Provider.of<CartProvider>(context);

    final filteredProducts = products.where((product) =>
    product.title.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results for \"$query\""),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text("No products found."))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ProductCard(
            imageUrl: product.imageUrl,
            title: product.title,
            price: product.price,
            rating: product.rating,
            onAddToCart: () {
              cartProvider.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} added to cart'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}