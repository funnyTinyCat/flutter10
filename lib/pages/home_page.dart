import 'package:auth_app04/components/my_textfield.dart';
import 'package:auth_app04/components/wall_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({

        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now()
      });

    }

    // clear the textfield
    setState(() {
      textController.clear();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("The Wall"),
        actions: [
          IconButton(
            onPressed: signUserOut, 
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("User Posts").orderBy(
                  "TimeStamp", 
                  descending: false).snapshots(),   
                builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) { 
                        // get the message
                        final post = snapshot.data!.docs[index];
                        
                        return WallPost(
                          message: post['Message'], 
                          user: post['UserEmail']
//                          time: post['Time'],
                        );
                      },  
                    );
                  } else if (snapshot.hasError) {

                    return Center(
                      child: Text('Error ' + snapshot.error.toString()),
                    );  
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
            ),

            // post message
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      controller: textController, 
                      hintText: 'Write something on the wall... ', 
                      obscureText: false),
              
                  ),
                  // post button
                  IconButton(
                    onPressed: postMessage, 
                    icon: Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),

            // logged in as            
            Center(
              child: Text(
                "Logged In as ${user.email!}", 
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ), 

              ),

            ),

            const SizedBox(height: 50,),

          ],          
        ),        
      ),
    );
  }
}