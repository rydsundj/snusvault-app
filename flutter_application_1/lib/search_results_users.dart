import 'package:flutter/material.dart';

//pretty much just a helper widget that can be resued if needed.
class SearchResults extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;
  final Function(String) onUserSelected;

  const SearchResults(
      {required this.searchResults, required this.onUserSelected, super.key});

  @override
  Widget build(BuildContext context) {
    if (searchResults.isEmpty) {
      return const Text("No users found.");
    }

    return Expanded(
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final user = searchResults[index];
          return ListTile(
            title: Text(user['username']),
            //passes the userId of the selected user back to the parent widget (HomeScreen) for navigation
            onTap: () => onUserSelected(user['id']),
          );
        },
      ),
    );
  }
}
