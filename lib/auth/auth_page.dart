import 'package:auth_app04/pages/home_page.dart';
import 'package:auth_app04/auth/login_or_register_page.dart';
import 'package:auth_app04/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // user is logged
          if ( snapshot.hasData) {
            return HomePage();
          }
          // user is NOT logged id
          else {
            return const LoginOrRegisterPage();
          }
        }
      ),
    ); 
  }
}