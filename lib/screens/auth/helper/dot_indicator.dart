import 'package:flutter/material.dart';

class AnimatedDotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color dotColor;
  final Color activeDotColor;
  final double dotSize;
  final double spacing;
  final Duration duration;

  const AnimatedDotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.dotColor = Colors.grey,
    this.activeDotColor = Colors.blue,
    this.dotSize = 8.0,
    this.spacing = 1,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: duration,
          width: index == currentIndex ? 25 : 10,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(dotSize / 2),
            color: index == currentIndex ? activeDotColor : dotColor,
          ),
        );
      }),
    );
  }
}
