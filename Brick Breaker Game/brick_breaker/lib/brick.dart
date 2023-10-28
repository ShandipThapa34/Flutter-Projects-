import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  const MyBrick({
    super.key,
    required this.brickX,
    required this.brickY,
    required this.brickHeight,
    required this.brickWidth,
    required this.brickBroken,
  });

  final double brickX;
  final double brickY;
  final double brickHeight;
  final double brickWidth;
  final bool brickBroken;

  @override
  Widget build(BuildContext context) {
    return brickBroken
        ? Container()
        : Container(
            alignment:
                Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple,
              ),
              height: MediaQuery.of(context).size.height * brickHeight / 2,
              width: MediaQuery.of(context).size.width * brickWidth / 2,
            ),
          );
  }
}
