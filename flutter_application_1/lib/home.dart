import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigationbar.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'search_results_users.dart';
import 'topsnus.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //related to temporarily storing things like search results
  //also to update UI depending on what the user has clicked on
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> topSnusList = [];
  bool showSearchResults = false;
  bool _isLoadingTopSnus = true;

// frees the memory used by the _searchController when the HomeScreen is removed from the widget tree.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

//queries firestore for users with usernames that start with the given search string.
  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) return;

    FirebaseFirestore db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    //uses setstate to trigger a rebuild and update searchResults and display the result
    setState(() {
      searchResults = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'username': doc['username'],
        };
      }).toList();
    });
  }

//fetches all products from all users, calculates scores, and sorts them.
  Future<List<Map<String, dynamic>>> fetchTopRatedSnus() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Map<String, dynamic>> allSnus = [];

    final usersSnapshot = await db.collection('users').get();

//nestled loop, get the products then the score
    for (var userDoc in usersSnapshot.docs) {
      final productsSnapshot =
          await userDoc.reference.collection('products').get();

      for (var productDoc in productsSnapshot.docs) {
        final productData = productDoc.data();
        final score = productData['score']?.toDouble() ?? 0.0;
// add to the allSnus list
        allSnus.add({
          'name': productData['name'],
          'score': score,
        });
      }
    }
    //sort by score in descending order
    allSnus.sort((a, b) => b['score'].compareTo(a['score']));

    //return the top 3 snus
    return allSnus.take(3).toList();
  }

//redirects users to the profile clicked on
  void _goToUserProfile(String userId) {
    final visitingUserId = FirebaseAuth.instance.currentUser?.uid;
    //if the user is itself then go to /me
    if (userId == visitingUserId) {
      context.go('/me');
    } else {
      context.go("/user_profile", extra: {
        "userId": userId,
        "visitingUserId": visitingUserId ?? "",
      });
    }
  }

//function to handle logout
  void handleLogout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await FirebaseAuth.instance.signOut();
    // prevents updating the state of a widget if it has been removed from the widget tree
    if (!mounted) return;
    userProvider.logout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTopSnus();
  }

  Future<void> _loadTopSnus() async {
    setState(() {
      _isLoadingTopSnus = true;
    });

    final snusList = await fetchTopRatedSnus();

    if (mounted) {
      setState(() {
        topSnusList = snusList;
        _isLoadingTopSnus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              './images/logo.jpg',
              fit: BoxFit.cover,
              height: 100,
            ),
            const SizedBox(height: 50),
            //search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //change ui when search is happening
                onChanged: (value) {
                  setState(() {
                    showSearchResults = true;
                  });
                  _searchUsers(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Search Results Widget
            if (showSearchResults)
              SearchResults(
                searchResults: searchResults,
                onUserSelected: _goToUserProfile,
              ),
            // Top Snus List Widget
            TopSnusList(
              topSnusList: topSnusList,
              isLoading: _isLoadingTopSnus,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => handleLogout(context),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
      //navigationbar for routing to other pages
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 0,
      ),
    );
  }
}
