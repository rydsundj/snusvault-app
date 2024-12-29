import 'package:flutter/material.dart';

//this widget dynamically displays search results  matching the search query
class ProductSearchResults extends StatelessWidget {
  final List<dynamic> products;
  final Function(String) onProductSelected;

  const ProductSearchResults(
      {required this.products, required this.onProductSelected, super.key});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Text('No products found.');
    }

    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            //each result displays the product name, brand and flavor
            title: Text(product.name),
            subtitle: Text('${product.brand}, ${product.flavor}'),
            //on selection, invokes a callback to pass the selected product name back to rate.dart
            onTap: () => onProductSelected(product.name),
          );
        },
      ),
    );
  }
}
