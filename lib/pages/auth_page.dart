// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
              // ignore: prefer_const_constructors
              gradient: LinearGradient(
                colors: [
                  Color(0x7C4506B1),
                  Color(0x62FD4C00),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 70,
                  ),
                  // cascade operator
                  // transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(0, 191, 54, 12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 8,
                    //     color: Colors.black26,
                    //     offset: Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: Text(
                    'Store ',
                    style: TextStyle(
                      
                      fontSize: 45,
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                ),
                AuthForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Exemplo usado para explicar o cascade operator
// void main() {
//   List<int> a = [1, 2, 3];
//   a.add(4);
//   a.add(5);
//   a.add(6);

//   // cascade operator!
//   a..add(7)..add(8)..add(9);

//   print(a);
// }