import 'models/product.dart';

/// Sample data provider for demonstration
class SampleData {
  static List<Product> getProducts() {
    return [
      Product(
        id: 1,
        name: 'Laptop',
        description: 'High-performance laptop for developers',
        price: 85000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        tags: ['electronics', 'computers'],
      ),
      Product(
        id: 2,
        name: 'Smartphone',
        description: 'Latest generation smartphone',
        price: 45000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        tags: ['electronics', 'mobile'],
      ),
      Product(
        id: 3,
        name: 'Headphones',
        description: 'Noise-cancelling wireless headphones',
        price: 15000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=3',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['electronics', 'audio'],
      ),
      Product(
        id: 4,
        name: 'Keyboard',
        description: 'Mechanical gaming keyboard',
        price: 8000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['electronics', 'accessories'],
      ),
      Product(
        id: 5,
        name: 'Monitor',
        description: '27-inch 4K display',
        price: 35000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=5',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['electronics', 'displays'],
      ),
      Product(
        id: 6,
        name: 'Mouse',
        description: 'Ergonomic wireless mouse',
        price: 3000,
        currency: 'RUB',
        imageUrl: 'https://picsum.photos/400/300?random=6',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['electronics', 'accessories'],
      ),
    ];
  }

  static Product? getProductById(int id) {
    try {
      return getProducts().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Product> getProductsByCategory(String? category) {
    if (category == null || category.isEmpty) {
      return getProducts();
    }
    return getProducts()
        .where((p) => p.tags.contains(category.toLowerCase()))
        .toList();
  }
}
