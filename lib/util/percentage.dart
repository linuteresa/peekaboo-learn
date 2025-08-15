import 'package:flutter/material.dart';

class PercentageIndicator extends StatelessWidget {
  final int percentage;

  const PercentageIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.0,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '$percentage% completed on this level',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
