// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/method/get_current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/member.dart';
import '../../../models/organization.dart';
import '../widgets/custom_text_field.dart';
import '../organization_provider/add_organization.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({super.key});

  @override
  State<CreateOrganizationPage> createState() => CreateOrganizationPageState();
}

class CreateOrganizationPageState extends State<CreateOrganizationPage> {
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveOrganization() async {
    final String docId = DateTime.now().millisecondsSinceEpoch.toString();
    final DocumentSnapshot userDoc =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    final AddOrganization addOrg =
        Provider.of<AddOrganization>(context, listen: false);

    setState(() {
      log('loading true');
      isLoading = true;
    });

    if (formKey.currentState!.validate()) {
      // member object for the admin
      Member admin = await getCurrentUserDetails();

      Organization org = Organization(
        id: docId,
        name: orgNameController.text,
        description: descriptionController.text,
        location: locationController.text,
        contactEmail: contactEmailController.text,
        contactPhone: contactPhoneController.text,
        createdDate:
            '${DateFormat.yMMMd().format(DateTime.now())}  ${DateFormat.jm().format(DateTime.now())}',
        adminId: auth.currentUser!.uid,
        adminName: userDoc['name'],
        members: [admin],
      );

      addOrg.addOrganizationToUser(organization: org, docId: docId);

      addOrg.incrementNumberOfOrg();

      // adding organization to all organizations collection
      addOrg.addOrganizationToAllOrgs(organization: org, docId: docId);

      Navigator.of(context).pop();

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Organization created successfully',
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please fill all the fields',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      log('loading false');
      isLoading = false;
    });

    return;
  }

  @override
  void dispose() {
    orgNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Organization'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: orgNameController,
                      labelText: 'Organization Name',
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      labelText: 'Description',
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.none,
                    ),
                    CustomTextField(
                      controller: locationController,
                      labelText: 'Location',
                    ),
                    CustomTextField(
                      controller: contactEmailController,
                      labelText: 'Contact Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: contactPhoneController,
                      labelText: 'Contact Phone',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      textInputAction: TextInputAction.done,
                    ),
                    // const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () async {
                          log('Clicked on Save button');
                          await saveOrganization();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
