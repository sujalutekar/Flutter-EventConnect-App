import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/member.dart';

Future<Member> getCurrentUserDetails() async {
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Member currentUser = Member.fromMap(snap.data() as Map<String, dynamic>);

  return currentUser;
}
