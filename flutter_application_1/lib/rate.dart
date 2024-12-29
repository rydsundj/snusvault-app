import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'navigationbar.dart';
import 'rating_box.dart';
import 'search_results_products.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  RateScreenState createState() => RateScreenState();
}

class RateScreenState extends State<RateScreen> {
  final TextEditingController _searchTerm = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int? selectedScore;
  String? selectedProduct;
  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  void dispose() {
    _searchTerm.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    //validates if a product is chosen
    if (selectedProduct == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a product first!')),
        );
      }
      return;
    }
//validates so a score is chosen and in the allowed span
    if (selectedScore == null || selectedScore! < 1 || selectedScore! > 10) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Score must be between 1 and 10!')),
        );
      }
      return;
    }

    String? comment =
        _commentController.text.isEmpty ? null : _commentController.text;

// add the actual product to the users snusvault
    await Provider.of<ProductProvider>(context, listen: false)
        .addProduct(selectedProduct!, selectedScore!, comment);

//clear the searchterm, update the state and nullify the chosen values
    _searchTerm.clear();
    setState(() {
      selectedProduct = null;
      selectedScore = null;
    });

//snackbar to show that the product was successfully added
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to snusVault')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //retrieve the products from the productprovider
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                //searchbar
                controller: _searchTerm,
                decoration: InputDecoration(
                  hintText: 'Search snus',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.all(12.0),
                ),
                onTap: () {
                  setState(() {
                    showSearchResults = true;
                  });
                },
                //on text change, displays search results dynamically
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            //print out the searchresults with the reusable widget
            if (showSearchResults && _searchTerm.text.isNotEmpty)
              ProductSearchResults(
                products: products
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(_searchTerm.text.toLowerCase()))
                    .toList(),
                onProductSelected: (productName) {
                  setState(() {
                    selectedProduct = productName;
                    selectedScore = null;
                    showSearchResults = false;
                    _searchTerm.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected $productName')),
                  );
                },
              ),
            //write out the product chosen
            if (selectedProduct != null) ...[
              Text(
                '$selectedProduct',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              //use the rating_box widget to let the user choose a score 1-10
              RatingBox(
                selectedScore: selectedScore,
                onScoreChanged: (value) {
                  //update the ui and save the score
                  setState(() {
                    selectedScore = value;
                  });
                },
                commentController: _commentController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                //call _saveproduct
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Save Product to snusVault',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}
