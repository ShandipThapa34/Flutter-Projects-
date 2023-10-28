import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({super.key, required this.playerX, required this.playerWidth});
  final double playerX;
  final double playerWidth; // out of 2

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment((2 * playerX + playerWidth) / (2 - playerWidth), 0.9),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple,
        ),
        height: 10,
        width: MediaQuery.of(context).size.width * playerWidth / 2,
      ),
    );
  }
}
