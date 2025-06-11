import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final VoidCallback? onAddToCart;
  final bool isInCart;

  const ProductCard({
    super.key,
    this.imageUrl = 'https://picsum.photos/200',
    this.title = 'Product Title',
    this.price = 29.99,
    this.rating = 4.5,
    this.onAddToCart,
    this.isInCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 151, // Strictly match the constraints
      height: 219.1, // Strictly match the constraints
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero, // Remove default card margin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Slightly smaller radius
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Image section (40% of total height)
                Container(
                  height: 88, // 219.1 * 0.4 ≈ 88
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                    ),
                  ),
                ),

                // Details section (60% of total height)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (fixed height, single line)
                      SizedBox(
                        height: 20,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Slightly smaller
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

// Full-width Add to Cart button
                      ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInCart ? Colors.grey : Colors.green,
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isInCart ? 'Added' : 'Add to Cart',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

            // Sale Badge (positioned absolutely)
            if (price < 30)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'SALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}