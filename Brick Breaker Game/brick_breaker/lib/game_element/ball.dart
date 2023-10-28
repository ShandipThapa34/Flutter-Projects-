import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({
    super.key,
    required this.ballX,
    required this.ballY,
    required this.hasGameStarted,
    required this.isGameOver,
  });
  final double ballX;
  final double ballY;
  final bool hasGameStarted;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              endRadius: 60.0,
              child: Material(
                elevation: 0.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
