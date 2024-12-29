import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigationbar.dart';
import 'product_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'snusvault_list.dart';
//displas another users profile

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String visitingUserId;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.visitingUserId,
  });

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  bool _isButtonPressed = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
    _fetchUsername();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchOtherUserProducts(widget.userId);
  }

//fetch the username via the userId that was given in the parameter
  Future<void> _fetchUsername() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc.data()?['username'];
      });
    }
  }

//check if the visiting user is following the user, if yes then we want to set the follow button to true and make it not clickable
  Future<void> _checkIfFollowing() async {
    final followingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.visitingUserId)
        .collection('following');

    final existingDoc = await followingRef.doc(widget.userId).get();
    if (existingDoc.exists) {
      setState(() {
        _isButtonPressed = true;
      });
    }
  }

//add the user to the visiting users following subcollection
  Future<void> _followUser() async {
    final followingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.visitingUserId)
        .collection('following');

    final existingDoc = await followingRef.doc(widget.userId).get();
    if (!existingDoc.exists) {
      await followingRef
          .doc(widget.userId)
          .set({'followedUserId': widget.userId});
      //update state and button
      setState(() {
        _isButtonPressed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final otherUserProducts = productProvider.otherUserProducts;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.go("/home");
              },
              tooltip: 'Go back',
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            Text(
              "${username ?? 'User'}'s SnusVault",
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(
                _isButtonPressed ? Icons.check : Icons.person_add,
              ),
              onPressed: _isButtonPressed ? null : _followUser,
              tooltip: 'Follow User',
              color: _isButtonPressed ? Colors.yellow : null,
            ),
          ],
        ),
      ),
      body: otherUserProducts.isEmpty
          ? const Center(child: Text('No products found in SnusVault'))
          : SnusVaultList(
              products: otherUserProducts,
              emptyMessage: 'No products found in SnusVault',
            ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}
