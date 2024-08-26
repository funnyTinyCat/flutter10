import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key, 
    required this.text, 
    required this.user, 
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
     //   color: Colors.grey[300],
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text,),

          const SizedBox(height: 6,),
          // user, time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[400],),
              ),
              Text(
                " - ",
                style: TextStyle(color: Colors.grey[400],)
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey[400],)    
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}