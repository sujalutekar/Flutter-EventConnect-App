import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../organization_provider/add_user_to_org.dart';

class JoinOrganizationPage extends StatefulWidget {
  const JoinOrganizationPage({super.key});

  @override
  State<JoinOrganizationPage> createState() => _JoinOrganizationPageState();
}

class _JoinOrganizationPageState extends State<JoinOrganizationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationIdController =
      TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void submitForm(String organizationId) async {
    final AddUser addUser = Provider.of<AddUser>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await addUser.addUserToOrganization(organizationId);

      if (addUser.message == 'Successfully joined organization') {
        _organizationIdController.clear();
        // ignore: use_build_context_synchronously
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Organization joined successfully',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Clear the message when the widget is initialized
    Future.microtask(() {
      final AddUser addUser = Provider.of<AddUser>(context, listen: false);
      addUser.clearMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Organization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _organizationIdController,
                decoration: const InputDecoration(labelText: 'Organization ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an organization ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => submitForm(_organizationIdController.text),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Join'),
              ),
              Consumer<AddUser>(
                builder: (context, adduser, child) {
                  return Text(
                    adduser.message,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
