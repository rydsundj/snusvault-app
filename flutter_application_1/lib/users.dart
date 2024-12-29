import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navigationbar.dart';
import 'package:go_router/go_router.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  List<Map<String, String>> followingUsers = [];

  @override
  void initState() {
    super.initState();
    //to load the list of users the current user follows
    _listenToFollowingUsers();
  }

  void _listenToFollowingUsers() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
//fetches user id from the following subcollection of the current user
      FirebaseFirestore db = FirebaseFirestore.instance;

      db
          .collection('users')
          .doc(user.uid)
          .collection('following')
          .snapshots()
          .listen((snapshot) async {
        List<Map<String, String>> users = [];
        //retrieves the usernames from the users collection

        for (var doc in snapshot.docs) {
          var userDoc = await db.collection('users').doc(doc.id).get();
          if (userDoc.exists) {
            var username = userDoc.data()?['username'];
            if (username != null) {
              users.add({'userId': doc.id, 'username': username});
            }
          }
        }
//set the state, update followingUsers

        if (mounted) {
          setState(() {
            followingUsers = users;
          });
        }
      });
    }
  }

//deletes the user ID from the following subcollection
  Future<void> _unfollowUser(String userId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection('users')
          .doc(user.uid)
          .collection('following')
          .doc(userId)
          .delete();
      //refresh the following user list
      _listenToFollowingUsers();
    }
  }

//redirects to the given user profile, if user is itself, go to /me
  void _goToUserProfile(String userId) {
    final visitingUserId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == visitingUserId) {
      context.go('/me');
    } else {
      context.go("/user_profile", extra: {
        "userId": userId,
        "visitingUserId": visitingUserId ?? "",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //if user doesnt follow anyone
      body: followingUsers.isEmpty
          ? const Center(
              child: Text("You are not following anyone yet."),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Following',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  //write out all the users
                  child: ListView.builder(
                    itemCount: followingUsers.length,
                    itemBuilder: (context, index) {
                      final user = followingUsers[index];
                      return ListTile(
                        title: Text(user['username']!),
                        onTap: () => _goToUserProfile(user['userId']!),
                        trailing: TextButton(
                          onPressed: () => _unfollowUser(user['userId']!),
                          child: const Text("Unfollow"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }
}
