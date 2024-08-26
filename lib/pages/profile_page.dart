import 'package:auth_app04/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // all users 
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // edit field
  Future<void> editField(String field) async {

    String newValue = "";
    bool flag = false;

    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit ${field}", 
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: Colors.white,            
          ),
          decoration: InputDecoration(
            hintText: "Enter new ${field}",
            hintStyle: TextStyle(color: Colors.grey,),
          ),
          onChanged: (value) {
            newValue = value; 
          },
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              flag = false;
            }, 
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white,),
            ),
          ),

          // save button
          TextButton(
            onPressed: () { 
              
              Navigator.of(context).pop(newValue);
            
            flag = true;
             
            }, 
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white,),
            ),
          ),

          // 

        ],
      ),
    );

   // update in firestore
  if ((newValue.trim().length > 0) && (flag == true)) {

    // only update if there is something in the textField
    await usersCollection.doc(currentUser.email).update({field: newValue});
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:  Text(
          "Profile Page",
   //       style: TextStyle(color: Theme.of(context).colorScheme.secondary,),  
         // style: TextStyle(color: Colors.grey[900],),  
        ),
  //      backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(), 
        builder: (context, snapshot) {
          
          // get user data
          if (snapshot.hasData)
          {
            
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50,),
                // profile picture
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 10,),
                // user email
                Text(
                  currentUser.email!,
                  style: TextStyle(color: Colors.grey[700],),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 50,),

                // user details
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600],),
                  ),
                ),


                // username
                MyTextBox(
                  text: userData['username'], 
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),

                // bio
                MyTextBox(
                  text: userData['bio'], 
                  sectionName: 'bio', 
                  onPressed: () => editField('bio'),
                ),

                const SizedBox(height: 50,),
                // user posts
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),

        



              ],
            );
          } else if (snapshot.hasError) {

            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}