import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/payment_method_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final product = cartProvider.cartItems[index];
                return ListTile(
                  leading: Image.network(product.imageUrl),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => cartProvider.removeFromCart(product),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \Rs. ${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
