import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/organization.dart';

class AddOrganization with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> incrementNumberOfOrg() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'numberOfYourOrg': FieldValue.increment(1),
    });
  }

  Future<void> decrementNumberOfOrg() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'numberOfYourOrg': FieldValue.increment(-1),
    });
  }

  Future<void> addOrganizationToUser({
    required Organization organization,
    required String docId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('yourOrganizations')
          .doc(docId)
          .set(organization.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addOrganizationToAllOrgs({
    required Organization organization,
    required String docId,
  }) async {
    try {
      await firestore
          .collection('allOrganizations')
          .doc(docId)
          .set(organization.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteOrganization({required String organizationId}) async {
    // delete the organization
    await firestore.collection('allOrganizations').doc(organizationId).delete();

    // delete the organization from the user's organization list
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('yourOrganizations')
        .doc(organizationId)
        .delete();

    // decrement the number of organizations
    await decrementNumberOfOrg();
  }

  Future<void> deleteEvent(
      String id, String orgId, int index, List<Event> events) async {
    try {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('allOrganizations').doc(orgId);

      if (events[index].id == id) {
        ref.update({
          'events': FieldValue.arrayRemove([events[index].toMap()]),
        });

        events.removeWhere((element) => element.id == events[index].id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
