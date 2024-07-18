// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/member.dart';
import '../widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final Member currentUser;

  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.currentUser.name;
    emailController.text = widget.currentUser.email;
    phoneController.text = widget.currentUser.phone.toString();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  bool checkDetailsChanged() {
    return nameController.text != widget.currentUser.name ||
        emailController.text != widget.currentUser.email ||
        phoneController.text != widget.currentUser.phone.toString();
  }

  Future<void> saveProfile() async {
    try {
      if (_formKey.currentState!.validate()) {
        bool isChanged = checkDetailsChanged();

        if (isChanged) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser.uid)
              .update({
            'name': nameController.text,
            'email': emailController.text,
            'phone': int.parse(phoneController.text),
          });

          Navigator.of(context).pop();

          QuickAlert.show(
            context: context,
            title: 'Profile Updated',
            text: 'Your profile has been updated successfully',
            type: QuickAlertType.success,
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No changes detected'),
            ),
          );
        }
      }
    } catch (e) {
      log('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              labelText: 'Name',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: phoneController,
              labelText: 'Phone',
              maxLength: 10,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: saveProfile,
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
    );
  }
}
