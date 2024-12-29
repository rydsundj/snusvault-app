import 'package:flutter/material.dart';
import 'product.dart';

//reusable widget used in both /user_profile and /me
class SnusVaultList extends StatelessWidget {
  final List<Product> products;
  final String emptyMessage;

  const SnusVaultList({
    super.key,
    required this.products,
    this.emptyMessage = "No products found.",
  });

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${product.name}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text('Score: ${product.score}'),
                      const SizedBox(height: 5),
                      Text('Comment: ${product.comment ?? 'No comment'}'),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
