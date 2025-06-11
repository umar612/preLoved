import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Image.network(
                  'https://picsum.photos/200',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Title',
                    style: Theme.of(context).textTheme.headlineMedium, // Replaced headline5
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$29.99',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium, // Replaced subtitle1
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}