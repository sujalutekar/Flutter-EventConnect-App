// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/event.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_time_picker.dart';

class CreateEventPage extends StatefulWidget {
  final String organizationId;

  const CreateEventPage({super.key, required this.organizationId});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController organizerController = TextEditingController();
  final TextEditingController startDateAndTimeController =
      TextEditingController();
  final TextEditingController endDateAndTimeController =
      TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveEvent() async {
    if (formKey.currentState!.validate()) {
      final String eventId = DateTime.now().millisecondsSinceEpoch.toString();

      Event event = Event(
        id: eventId,
        name: eventNameController.text,
        description: descriptionController.text,
        location: locationController.text,
        organizer: organizerController.text,
        createdDate:
            '${DateFormat.yMMMd().format(DateTime.now())}  ${DateFormat.jm().format(DateTime.now())}',
        startDateTime: startDateAndTimeController.text,
        endDateTime: endDateAndTimeController.text,
      );

      await firestore
          .collection('allOrganizations')
          .doc(widget.organizationId)
          .update(
        {
          'events': FieldValue.arrayUnion([event.toMap()]),
        },
      );

      // new collection for events
      await firestore
          .collection('allOrganizations')
          .doc(widget.organizationId)
          .collection('events')
          .doc(eventId)
          .set(event.toMap());

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Event created successfully',
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
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    organizerController.dispose();
    startDateAndTimeController.dispose();
    endDateAndTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: eventNameController,
                labelText: 'Event Name',
              ),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Event Description',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.none,
              ),
              CustomTextField(
                controller: locationController,
                labelText: 'Event Location',
              ),
              CustomTextField(
                controller: organizerController,
                labelText: 'Organizer Name',
              ),
              DateAndTimePicker(
                controller: startDateAndTimeController,
                labelText: 'Start Date and Time',
              ),
              DateAndTimePicker(
                controller: endDateAndTimeController,
                labelText: 'End Date and Time',
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    log('Clicked on Save button');
                    await saveEvent();
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
