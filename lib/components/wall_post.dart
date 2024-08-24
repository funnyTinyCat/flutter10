import 'package:auth_app04/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class WallPost extends StatefulWidget {
  final String message;
  final String user;  
  final String  postId;
  final List<String> likes;
//  final String time;

  const WallPost({
    super.key, 
    required this.message, 
    required this.user, 
    required this.postId, 
    required this.likes, 
  //  required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // user 
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike() {

    setState(() {
      isLiked = !isLiked;  
    });

    // access the document in firebase
    DocumentReference postRef = 
      FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }

  }


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
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey[400],
              
          //   ),

          //   padding: EdgeInsets.all(10),
          //   child: Icon(
          //     Icons.person, 
          //     color: Colors.white,
          //   ),
          // ),
          Column(
            children: [
              // like button
              LikeButton(
                isLiked: isLiked, 
                onTap: toggleLike,
              ),

              const SizedBox(width: 6,),
              // like count
              Text(
                widget.likes.length.toString(),
                style: TextStyle(color: Colors.grey,),
              ),

            ],
          ),
          const SizedBox(width: 12,),
          Column(
            // message and user email
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 8,),
              Text(widget.message),
            ],
          )
        ],
      ),
    );
  }
}