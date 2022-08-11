import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/auth_screens/login_screen.dart';
import 'package:notes_firebase_app/services/firestore_functions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _wordController = TextEditingController();
  TextEditingController _meaningController = TextEditingController();
  bool newWordLoading = false;
  bool logOutLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vocabulary",
          style: TextStyle(color: Colors.blue, fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  logOutLoading = true;
                });
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                setState(() {
                  logOutLoading = false;
                });
              },
              icon: logOutLoading
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ))
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: userWords.snapshots(), //build connection
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length, //number of rows
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        "Word: " + documentSnapshot['word'],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Meaning: " + documentSnapshot['meaning'].toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 0.5),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
// This icon button is used to delete a single product
                            IconButton(
                                onPressed: () async {
                                  await deleteWords(documentSnapshot.id);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              isScrollControlled: true,
              backgroundColor: Colors.black,
              context: context,
              builder: (context) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.50,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _wordController,
                        decoration: const InputDecoration(
                          hintText: "Enter your word",
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _meaningController,
                        decoration: const InputDecoration(
                          hintText: "Enter your word meaning",
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        splashColor: Colors.blueGrey,
                        onTap: () async {
                          if (_wordController.text.isNotEmpty) {
                            if (_meaningController.text.isNotEmpty) {
                              setState(() {
                                newWordLoading = true;
                              });
                              // Add the word and meaning to firestore firebase
                              await addWords(_wordController.text,
                                  _meaningController.text);
                              _wordController.text = "";
                              _meaningController.text = "";
                              setState(() {
                                newWordLoading = false;
                              });
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: newWordLoading
                            ? CircularProgressIndicator()
                            : Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[900],
                                ),
                                child: const Center(
                                    child: Text(
                                  "Add new word",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      letterSpacing: 0.3),
                                )),
                              ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
