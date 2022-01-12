import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_and_authntications/servicea/notifications_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../sign_up.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUserToken();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      LocalNotificationService.display(message);
    });

  }

  updateUserToken() async {

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'token':deviceToken,

    },SetOptions(merge: true));
  }

  bool isLoading = false;

  final Stream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    print("\n\n\n\n\n\n\n\n\n\n\n\n");
    print("token is $token");
    print("\n\n\n\n\n\n\n\n\n\n\n\n");

    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'message': message
    };

    try {
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':

              // 'key=AAAAmVXvuHg:APA91bEflc3NMlozM4A7i3mfu6wG_8xo7mGFcSNamRUAJmX3RDUMzv8zvNc_a8ogwX6p3-lPQP0c3HgYqcav4c79LuNAWDB7P6hkh9b8tomzWYmaijkw-9E3v4Tt0GX6QMQw6O5kL1DX',
              'key=AAAACDUYpeY:APA91bEtD1UB3OAgwEPnUWFxRCi51wIZSDEJpRg-mWbhtMxN88clMQAwa8qMpjlP2JPFHMojdjZc_LarqQwybRuFvqg4iVRxUZiJTHrquz4L_P7yjvPJJR6EaX2xzxhR80g_nwMKfvnl',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "$token"
          },
        ),
      );

      print(r.body);
      if (r.statusCode == 200) {
        print('DOne');
      } else {
        print(r.statusCode);
      }
    } catch (e) {
      print('exception $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();


            Navigator.push(context, MaterialPageRoute(builder: (ctx)=> Sign_up(),),);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: Stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      List followList = snapshot.data!.get('followId');
                      TextEditingController nameController =
                          TextEditingController(
                        text: snapshot.data!.get('Name'),
                      );
                      TextEditingController emailController =
                          TextEditingController(
                        text: snapshot.data!.get('Email'),
                      );
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     pickImage(docId: snapshot.data!.id);
                          //   },
                          //   child: file != null
                          //       ? CircleAvatar(
                          //     radius: 45,
                          //     backgroundColor: Colors.blue,
                          //     backgroundImage: FileImage(File(file!.path)),
                          //   )
                          //       : CircleAvatar(
                          //     backgroundColor: Colors.grey,
                          //     radius: 40,
                          //     backgroundImage: NetworkImage(
                          //       snapshot.data!.get('imageUrl'),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              enabled: false,
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'UserName',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              enabled: false,
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'UserEmail'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Following : ${followList.length}',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     isLoading
                          //         ? const CircularProgressIndicator()
                          //         : ElevatedButton(
                          //       onPressed: () async {
                          //         isLoading = true;
                          //         setState(() {});
                          //         try {
                          //           await FirebaseFirestore.instance
                          //               .collection('users')
                          //               .doc(FirebaseAuth
                          //               .instance.currentUser!.uid)
                          //               .set(
                          //             {
                          //               'Name': nameController.text,
                          //             },
                          //             SetOptions(merge: true),
                          //           ).then((value) {
                          //             isLoading = false;
                          //             setState(() {});
                          //           }).catchError((e) {
                          //             Get.snackbar(
                          //                 'title', '$e'.toString());
                          //           });
                          //           Get.snackbar(
                          //               'Message', nameController.text);
                          //         } catch (e) {
                          //           Get.snackbar('title', '$e');
                          //         }
                          //       },
                          //       child: const Text('Update'),
                          //     ),
                          //
                          //   ],
                          // ),

                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, secSnapshot) {
                              if (!secSnapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              return ListView.builder(
                                itemCount: secSnapshot.data!.docs.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  // List followList =
                                  //     snapshots.data!.docs[i].get('followId');
                                  String? token;
                                  try {
                                    token = secSnapshot.data!.docs[i]
                                        .get('tokenId');
                                  } catch (e) {}
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  final docId = secSnapshot.data!.docs[i].id;
                                  return Container(
                                    margin: const EdgeInsets.all(15),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        color: Colors.red),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              secSnapshot.data!.docs[i]['Name'],
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                                secSnapshot.data!.docs[i]
                                                    ['Email'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ))
                                          ],
                                        ),
                                        const Spacer(),
                                        followList.contains(docId)
                                            ? TextButton(
                                                onPressed: () {
                                                  sendNotification(
                                                    title:"${nameController.text} Unfollowed you",
                                                    message: 'sa hisab do',
                                                    token: '${secSnapshot.data!.docs[i]['token']}',
                                                    // token: token,
                                                  );

                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .set(
                                                    {
                                                      'followId': FieldValue
                                                          .arrayRemove(
                                                        [docId],
                                                      )
                                                    },
                                                    SetOptions(merge: true),
                                                  );
                                                },
                                                child: const Text(
                                                  'unfollow',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  sendNotification(
                                                    title:"${nameController.text} followed you",
                                                    message: 'sa hisab do',
                                                    token: '${secSnapshot.data!.docs[i]['token']}',
                                                     //token: token,
                                                  );
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .set(
                                                    {
                                                      'followId':
                                                          FieldValue.arrayUnion(
                                                        [docId],
                                                      )
                                                    },
                                                    SetOptions(merge: true),
                                                  );
                                                },
                                                child: const Text('follow',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20)),
                                              )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
