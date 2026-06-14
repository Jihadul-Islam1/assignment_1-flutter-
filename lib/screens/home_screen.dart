import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    // Sample products
    products = [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        price: 999.99,
        imageUrl: 'https://picsum.photos/id/0/200/200',
        description: 'Latest Apple smartphone with A17 chip',
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        price: 899.99,
        imageUrl: 'https://picsum.photos/id/1/200/200',
        description: 'Premium Android smartphone',
      ),
      Product(
        id: '3',
        name: 'Sony Headphones',
        price: 299.99,
        imageUrl: 'https://picsum.photos/id/2/200/200',
        description: 'Noise cancelling headphones',
      ),
      Product(
        id: '4',
        name: 'MacBook Pro',
        price: 1299.99,
        imageUrl: 'https://picsum.photos/id/3/200/200',
        description: 'Powerful laptop for professionals',
      ),
      Product(
        id: '5',
        name: 'iPad Air',
        price: 599.99,
        imageUrl: 'https://picsum.photos/id/4/200/200',
        description: 'Versatile tablet',
      ),
    ];
    filteredProducts = List.from(products);
  }

  void searchProducts(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addToCart(Product product) {
    setState(() {
      product.quantity++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void removeFromCart(Product product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} removed from cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  int get totalCartItems {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  double get totalPrice {
    return products.fold(0, (sum, product) => sum + (product.price * product.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecommerce Store'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  showCartDialog();
                },
              ),
              if (totalCartItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$totalCartItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            onSearch: searchProducts,
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filteredProducts[index],
                        onAdd: () => addToCart(filteredProducts[index]),
                        onRemove: () => removeFromCart(filteredProducts[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Shopping Cart'),
          content: SizedBox(
            width: double.maxFinite,
            child: products.where((p) => p.quantity > 0).isEmpty
                ? const Center(child: Text('Cart is empty'))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.where((p) => p.quantity > 0).length,
                          itemBuilder: (context, index) {
                            final product = products.where((p) => p.quantity > 0).toList()[index];
                            return ListTile(
                              leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(product.name),
                              subtitle: Text('\$${product.price.toStringAsFixed(2)} x ${product.quantity}'),
                              trailing: Text('\$${(product.price * product.quantity).toStringAsFixed(2)}'),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total: \$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            if (totalCartItems > 0)
              ElevatedButton(
                onPressed: () {
                  // Implement checkout
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout functionality coming soon!')),
                  );
                },
                child: const Text('Checkout'),
              ),
          ],
        );
      },
    );
  }
}