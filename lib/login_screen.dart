import 'package:firebase_and_authntications/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_screen.dart';
class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  TextEditingController emailcontroller = TextEditingController(text: 'aswand@gmail.com');
  TextEditingController passwordcontroller = TextEditingController(text: '123456');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.4),
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(28)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.4),
                  hintText: "Password",

                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(28)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                height: 70,
                minWidth: 200,
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text,)
                      .then((value) {
                    Get.to(home_screen());
                  });
                },
                shape: const StadiumBorder(),
                color: Colors.amber,
                child: const Text("Sign in "),
              ),
              MaterialButton(
                onPressed: ()  {
                  Get.to(() =>  Sign_up(),);
                },
                child:const Text('Do not have account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
