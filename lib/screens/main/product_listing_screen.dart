import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'add_product_screen.dart';
import '/models/product_model.dart';
import '/providers/product_provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when screen loads
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  void _deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(productId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(initialProduct: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddProductScreen()),
            ),
          ),
        ],
      ),

      body: productProvider.products.isEmpty
          ? const Center(
        child: Text(
          'No products available.\nClick the + button to add one.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            final product = productProvider.products[index];
            return Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: product.imageUrl.startsWith('http')
                        ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      File(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonPadding: EdgeInsets.zero,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: Colors.blue,
                        onPressed: () => _navigateToEditScreen(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red,
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}