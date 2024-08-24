import 'package:auth_app04/components/my_button.dart';
import 'package:auth_app04/components/my_textfield.dart';
import 'package:auth_app04/components/square_tile.dart';
import 'package:auth_app04/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  
// wrong email message popup
  void showErrorMessage(String message) {

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      }
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {

    showDialog(
      context: context, 
      builder: (context) {

        return const AlertDialog(
          title: Text("Too many requests"),
        );
      }
    );
  }

  // sign user in method
  void signUserIn() async {


    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {

        return const Center( 
          child: CircularProgressIndicator(),
        );
      }
    );

    // try sign in
    try{

      await FirebaseAuth.instance.signInWithEmailAndPassword(

        email: emailController.text,
        password: passwordController.text,
      );

      // pop the loading circle
      if (context.mounted) 
        Navigator.pop(context);  
     
    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);

      print(e.code);

      showErrorMessage(e.code);
      // wrong email
   //   if (e.code == 'invalid-credential') {
        // show error to user
        // print("Not found user for this email");
      //   wrongEmailMessage();
      // } 
      // wrong password
    //  else if (e.code == 'too-many-requests') {
        // show error to user
        // print("Wrong password buddy");
      //   wrongPasswordMessage();
      // }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(        
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
            
                const SizedBox(height: 50,),
                // welcome back, you have been missed
                Text(
                  "Welcome back you've been missed",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),  
                ),                            
            
                const SizedBox(height: 24,),
            
                // username textfield
                MyTextfield(
                  controller: emailController, 
                  obscureText: false,
                  hintText: 'Email',  
                ),
            
                const SizedBox(height: 10,),
                // password textfield
                MyTextfield(
                  controller: passwordController,
                  obscureText: true,
                  hintText: 'Password',
                ),
            
                const SizedBox(height: 10,),
                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 24,),
                // sign in button
                MyButton(onTap: signUserIn, text: "Sign In",),
            
                const SizedBox(height: 50,),
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child:  Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey[700],),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 50,),    
                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                      imagePath: "lib/images/google.png", 
                      onTap: () => AuthService().signInWithGoogle(),),
            
                    const SizedBox(width: 20,),
                    // apple button
                    SquareTile(imagePath: "lib/images/apple.png", onTap:  () {},),
                  ],
                ),
            
                const SizedBox(height: 50,),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
            
                    const SizedBox(width: 6,),
            
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}