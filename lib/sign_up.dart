import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'login_screen.dart';
class Sign_up extends StatefulWidget {
  const Sign_up({Key? key}) : super(key: key);

  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  AuthController? authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String? name, email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: namecontroller,
                  onSaved: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Requred';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: emailcontroller,
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Requred';
                    }
                    if (!value.contains('@')) {
                      return 'enter valid email';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: passwordcontroller,
                  onSaved: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Requred';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      authController!.CreateMyUser(
                        email: email,
                        password: password,
                        name: name,


                      );

                    } else {
                      return;
                    }
                  },
                  child: Text('Create Account'),
                ),
                MaterialButton(
                  onPressed: () {
                    Get.to(() => loginscreen());
                  },
                  child: Text('Already have account'),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
