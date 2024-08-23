import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  
  final String imagePath;
  final Function()? onTap;

  SquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white,),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Image.asset(
          imagePath,
          height: 72,
        ),
      ),
    );
  }
}