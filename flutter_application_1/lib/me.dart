import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_provider.dart';
import 'product_provider.dart';
import 'navigationbar.dart';
import 'package:go_router/go_router.dart';
import 'snusvault_list.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  MeScreenState createState() => MeScreenState();
}

class MeScreenState extends State<MeScreen> {
  String? username;
  int ratedSnusCount = 0;
  int totalSnusCount = 100;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    //use the product provider to fetch the users products
    Provider.of<ProductProvider>(context, listen: false).fetchUserProducts();
  }

//fetch username via the user id
  Future<void> _fetchUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc.data()?['username'];
        });
      }
    }
  }

//if the user logs out
  void handleLogout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    userProvider.logout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProducts = productProvider.userProducts;
    ratedSnusCount = userProducts.length;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            username != null
                ? Column(
                    children: [
                      Text(
                        username!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => handleLogout(context),
                        child: const Text('Log out'),
                      ),
                      const SizedBox(height: 10),
                      // Show a progress bar of rated products
                      LinearProgressIndicator(
                        value: totalSnusCount > 0
                            ? ratedSnusCount / totalSnusCount
                            : 0,
                        backgroundColor: Colors.grey[300],
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$ratedSnusCount of $totalSnusCount rated',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Expanded(
              child: userProducts.isEmpty
                  ? const Center(child: Text('No products rated yet.'))
                  : SnusVaultList(
                      products: userProducts,
                      emptyMessage: 'No products rated yet.',
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}
