// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:event_connect/models/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import './custom_text_field.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priorityController.dispose();
    statusController.dispose();

    super.dispose();
  }

  Future<int> checkPriorityNumber() async {
    if (priorityController.text == 'low') {
      return 1;
    } else if (priorityController.text == 'medium') {
      return 2;
    } else if (priorityController.text == 'high') {
      return 3;
    }

    return 0;
  }

  Future<void> saveTodo() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (formKey.currentState!.validate()) {
        final int priorityNumber = await checkPriorityNumber();
        final String id = Timestamp.now().millisecondsSinceEpoch.toString();

        Todo todo = Todo(
          id: id,
          title: titleController.text,
          description: descriptionController.text,
          createdDate: DateFormat.yMMMd().format(DateTime.now()),
          priority: priorityController.text,
          status: 'pending',
          priorityNumber: priorityNumber,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('todo')
            .doc(id)
            .set(todo.toMap());

        Navigator.of(context).pop();

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Todo created successfully',
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      log('Todo Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: titleController,
                labelText: 'Title',
              ),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.none,
              ),

              // priority drop down menu
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownMenu(
                  initialSelection: 'medium',
                  controller: priorityController,
                  label: const Text('Priority'),
                  onSelected: (value) {
                    setState(() {
                      priorityController.text = value!;
                    });
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'low', label: 'low'),
                    DropdownMenuEntry(value: 'medium', label: 'medium'),
                    DropdownMenuEntry(value: 'high', label: 'high'),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    log('Clicked on Save button');
                    await saveTodo();
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
