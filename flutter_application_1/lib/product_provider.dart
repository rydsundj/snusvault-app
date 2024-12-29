import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = []; //all snus
  List<Product> _userProducts = []; //user-rated products
  List<Product> _otherUserProducts = []; // Other user's products

  List<Product> get products => _products;
  List<Product> get userProducts => _userProducts;
  List<Product> get otherUserProducts => _otherUserProducts;

  //fetch all snus products from the snus firestore collection
  Future<void> fetchProducts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot = await db.collection('snus').get();
    _products = snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data(), doc.id);
    }).toList();

    notifyListeners(); //tells widgets listening to the provider that the state has changed, to rebuild ui
  }

  //fetch user-rated products from the 'users/{userId}/products' collection
  Future<void> fetchUserProducts() async {
    //retrieves the currently authenticated user.
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
//navigates to users/{userId}/products collection
      db
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .snapshots()
          .listen((snapshot) {
        //converts firestore documents Product objects and updates _userProducts
        _userProducts = snapshot.docs.map((doc) {
          return Product.fromFirestore(doc.data(), doc.id);
        }).toList();

        notifyListeners();
      });
    }
  }

  // Fetch products for any user by their ID
  Future<void> fetchOtherUserProducts(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot =
        await db.collection('users').doc(userId).collection('products').get();

    _otherUserProducts = snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data(), doc.id);
    }).toList();

    notifyListeners();
  }

  //add a product to the user's rated list
  Future<void> addProduct(String name, int score, String? comment) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && name.isNotEmpty && score >= 1 && score <= 10) {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection('users').doc(user.uid).collection('products').add({
        'name': name,
        'score': score,
        'comment': comment,
      });

      notifyListeners();
    }
  }
}
