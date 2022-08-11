import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

CollectionReference userWords = FirebaseFirestore.instance
    .collection(FirebaseAuth.instance.currentUser!.uid);

Future<void> addWords(String word, String meaning) async {
  await userWords.add({
    'word': word,
    'meaning': meaning,
  });
}

Future<void> deleteWords(String wordId) async {
  await userWords.doc(wordId).delete();
}

Future<void> updateWord(String wordId, String word, String meaning) async {
  await userWords.doc(wordId).update({'word': word, 'meaning': meaning});
}
