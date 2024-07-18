import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/method/get_current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/member.dart';

class AddUser with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String message = '';

  Future<bool> validateOrganizationId(String organizationId) async {
    DocumentSnapshot doc = await firestore
        .collection('allOrganizations')
        .doc(organizationId)
        .get();
    return doc.exists;
  }

  Future<void> addUserToOrganization(String organizationId) async {
    Member currentUser = await getCurrentUserDetails();

    bool isValid = await validateOrganizationId(organizationId);

    if (isValid) {
      try {
        DocumentReference organizationRef = FirebaseFirestore.instance
            .collection('allOrganizations')
            .doc(organizationId);

        // check if the user is already a member of the organization
        DocumentSnapshot doc = await organizationRef.get();
        List<dynamic> members = doc['members'];

        if (members.any((member) => member['uid'] == currentUser.uid)) {
          message = 'You are already a member of this organization';
          notifyListeners();

          return;
        } else {
          await organizationRef.update(
            {
              'members': FieldValue.arrayUnion([currentUser.toMap()]),
            },
          ).then((_) {
            message = 'Successfully joined organization';
            notifyListeners();
          });
        }
      } catch (error) {
        message = 'Error joining organization';
        notifyListeners();
      }
    } else {
      message = 'Invalid Organization ID';
      notifyListeners();
    }
  }

  void clearMessage() {
    message = '';
    notifyListeners();
  }
}
