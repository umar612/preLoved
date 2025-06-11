import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../screens/cart_screen.dart';
import '../../screens/search_screen.dart';
import '../../providers/ThemeProvider.dart';
import 'chat_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'add_product_screen.dart';
import 'product_listing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ['All', 'Women', 'Men', 'Kids', 'Trending'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('$category Products')),
          body: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final categoryProducts = category == 'All'
                  ? productProvider.products
                  : productProvider.getProductsByCategory(category);
              return GridView.builder(
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
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final featuredProducts = productProvider.products
        .where((product) => product.rating >= 4.5)
        .take(4)
        .toList();

    final recentProducts = productProvider.products.take(6).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Pre-Loved Finds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductListingScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(query: query),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryChip(
                            label: categories[index],
                            isSelected: _selectedCategoryIndex == index,
                            onCategorySelected: (category) {
                              setState(() => _selectedCategoryIndex = index);
                              _navigateToCategory(context, category);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Items',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 180,
                        child: ProductCard(
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = recentProducts[index];
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
                  childCount: recentProducts.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'add_product',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'cart',
              onPressed: () => Navigator.pushNamed(context, '/cart'),
              backgroundColor: Theme.of(context).primaryColor,
              child: Badge(
                label: Text(cartProvider.cartItems.isNotEmpty
                    ? '${cartProvider.cartItems.length}'
                    : ''),
                isLabelVisible: cartProvider.cartItems.isNotEmpty,
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
