import 'package:flutter/material.dart';

//widget to show the top 3 rated snus fetched by fetchTopRatedSnus in Home
class TopSnusList extends StatelessWidget {
  final List<Map<String, dynamic>> topSnusList;
  final bool isLoading;

  const TopSnusList(
      {required this.topSnusList, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    //show a loading symbol
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (topSnusList.isEmpty) {
      return const Text('No ratings available');
    }

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Top 3 Rated Snus',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            //loop through all the fetched snus and display them
            for (var snus in topSnusList)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snus['name'] ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text('Rating: ${snus['score']}',
                        style: const TextStyle(fontSize: 13.0)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
