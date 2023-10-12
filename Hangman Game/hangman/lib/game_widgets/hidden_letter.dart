import 'package:flutter/material.dart';
import 'package:hangman/const/const.dart';

Widget hiddenLetter(String char, bool visible) {
  return Container(
    width: 40,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
    ),
    child: Visibility(
      visible: !visible,
      child: Text(
        char,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.bgColor),
      ),
    ),
  );
}
