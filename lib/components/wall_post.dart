import 'package:auth_app04/components/comment.dart';
import 'package:auth_app04/components/comment_button.dart';
import 'package:auth_app04/components/delete_button.dart';
import 'package:auth_app04/components/like_button.dart';
import 'package:auth_app04/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class WallPost extends StatefulWidget {
  final String message;
  final String user;  
  final String time;
  final String  postId;
  final List<String> likes;
//  final String time;

  const WallPost({
    super.key, 
    required this.message, 
    required this.user, 
    required this.time,
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

  // comment text controller
  final commentTextController = TextEditingController();


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

  // add a comment


  // show a dialog box for adding comment
  void addComment(String commentText) {

    // write the comment to firestore under the comments collection for this post 
    FirebaseFirestore.instance.collection("User Posts")
      .doc(widget.postId).collection("Comments").add({
        "CommentText" : commentText,
        "CommentedBy" : currentUser.email,
        "CommentTime" : Timestamp.now(),
      });
  }

  // show a dialog box for adding comment
  void showCommentDialog() {

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Add Comment", ),
        content: TextField(

          controller: commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment"),
        ),
        actions: [
          // save button
          TextButton(
            onPressed: () { 
              // add comment
              addComment(commentTextController.text);

              // pop box
              Navigator.pop(context);

              // clear the controller
              commentTextController.clear();
            }, 
            child: const Text("Post")
          ),

          // cancel button
          TextButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              commentTextController.clear();
            }, 
            child: const Text("Cancel"),
          ),

        ],
      )
    );
  }

  // delete a post
  void deletePost() {

    // show a dialog box asking for confirmation before deleting the post
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              "Cancel",
//              style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
            ),
          ), 

          // delete button
          TextButton(
            onPressed: () async {
              // delete comments from firestore first
              final commentDocs = 
                await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
                  .collection("Comments").get();
              
              for (var doc in  commentDocs.docs) {

                await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
                  .collection("Comments").doc(doc.id).delete();
              }

              // then delete the post
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete()
                .then((value) => print("Post deleted"))
                .catchError((error) => print("failed to delete post: $error"));

              // dismiss the dialog
              Navigator.pop(context);

            },           
            child: Text(
              "Delete",
//              style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
            ),
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
   //     color: Colors.grey[200],
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24,),
      padding: const EdgeInsets.all(24,),
      child: Column(
        
        children: [
          // wallpost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // group of text (message + user email)
              Column(
                // message and user email
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // message
                  Text(widget.message),
                  
                  const SizedBox(height: 8,),
              
                  // user, time
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400],),
                      ),
                      Text(
                        " - ",
                        style: TextStyle(color: Colors.grey[400],)
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400],)    
                      ),
                    ],
                  ),
              
              
                  // user
                  // Text(
                  //   widget.user,
                  //   style: TextStyle(
                  //     color: Colors.grey[500],
                  //   ),
                  // ),
                ],
              ),
              // delete button
              if (widget.user == currentUser.email)
                DeleteButton(
                  onTap: deletePost,
                ),
            ],
          ),

          const SizedBox(height: 10,),
          // buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
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

              const SizedBox(width: 10,),
              // COMMENT
              Column(
                children: [
                  // comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(width: 6,),
                  // like count
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey,),
                  ),

                ],
              ),

            ],
          ),

          const SizedBox(height: 10,),
          // comments under the post
          StreamBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              //show loading circle if there is no data yet
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, // for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get the comment from firebase
                  final commentData = doc.data() as Map<String, dynamic>;

                  // return the comment
                  return Comment(
                    text: commentData["CommentText"], 
                    user: commentData["CommentedBy"], 
                    time: formatDate(commentData["CommentTime"])
                  ); 

                }).toList(),

              );
              
            },
            stream: FirebaseFirestore.instance.collection("User Posts")
              .doc(widget.postId).collection("Comments")
              .orderBy("CommentTime", descending: true)
              .snapshots(),
          ),

        ],
      ),
    );
  }
}