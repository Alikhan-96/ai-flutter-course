import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/product.dart';
import '../../data/sample_data.dart';
import '../widgets/product_card.dart';

/// Product list page demonstrating cached_network_image and go_router query params
class ProductListPage extends StatelessWidget {
  final String? category;

  const ProductListPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final List<Product> products = SampleData.getProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          if (category != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Text(
                'Filtered by category: $category',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: category == null,
                  onSelected: (_) => context.push('/products'),
                ),
                FilterChip(
                  label: const Text('Electronics'),
                  selected: category == 'electronics',
                  onSelected: (_) =>
                      context.push('/products?category=electronics'),
                ),
                FilterChip(
                  label: const Text('Accessories'),
                  selected: category == 'accessories',
                  onSelected: (_) =>
                      context.push('/products?category=accessories'),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        sourceScreen: 'list${category != null ? '_$category' : ''}',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
