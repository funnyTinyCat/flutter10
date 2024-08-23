import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class WallPost extends StatelessWidget {
  final String message;
  final String user;
//  final String time;

  const WallPost({
    super.key, 
    required this.message, 
    required this.user, 
  //  required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24,),
      padding: const EdgeInsets.all(24,),
      child: Row(
        children: [
          // profile picture
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
              
            ),

            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person, 
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12,),
          Column(
            // message and user email
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 8,),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}