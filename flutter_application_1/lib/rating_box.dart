import 'package:flutter/material.dart';

class RatingBox extends StatelessWidget {
  final int? selectedScore;
  final Function(int) onScoreChanged;
  final TextEditingController commentController;

  const RatingBox({
    required this.selectedScore,
    required this.onScoreChanged,
    required this.commentController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedScore,
              hint: const Text('Select score (1-10)'),
              isExpanded: true,
              items: List.generate(10, (index) => index + 1)
                  .map((score) => DropdownMenuItem<int>(
                        value: score,
                        child: Text(score.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onScoreChanged(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: commentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add an optional comment',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.all(12.0),
          ),
        ),
      ],
    );
  }
}
