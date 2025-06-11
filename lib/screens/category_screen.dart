import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Women',
    'Men',
    'Kids',
    'Accessories',
    'Electronics',
    'Home',
  ];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProducts = _selectedCategory == 'All'
        ? productProvider.products
        : productProvider.getProductsByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Text('$_selectedCategory Products'),
      ),
      body: Column(
        children: [
          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return CategoryChip(
                  label: _categories[index],
                  isSelected: _categories[index] == _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                final product = categoryProducts[index];
                return ProductCard(
                  imageUrl: product.imageUrl,
                  title: product.title,
                  price: product.price,
                  rating: product.rating,
                  onAddToCart: () {
                    // Implement cart logic here
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
