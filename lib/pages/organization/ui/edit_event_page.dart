// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/event.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_time_picker.dart';

class EditEventPage extends StatefulWidget {
  final String organizationId;
  final Event event;

  const EditEventPage(
      {super.key, required this.organizationId, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
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

  bool isDetailsChanged() {
    return eventNameController.text != widget.event.name ||
        descriptionController.text != widget.event.description ||
        locationController.text != widget.event.location ||
        organizerController.text != widget.event.organizer ||
        startDateAndTimeController.text != widget.event.startDateTime ||
        endDateAndTimeController.text != widget.event.endDateTime;
  }

  Future<void> saveEvent() async {
    try {
      if (formKey.currentState!.validate()) {
        bool isChanged = isDetailsChanged();

        Event event = Event(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: eventNameController.text,
          description: descriptionController.text,
          location: locationController.text,
          organizer: organizerController.text,
          createdDate: widget.event.createdDate,
          startDateTime: startDateAndTimeController.text,
          endDateTime: endDateAndTimeController.text,
        );

        if (isChanged) {
          DocumentSnapshot snap = await firestore
              .collection('allOrganizations')
              .doc(widget.organizationId)
              .get();

          // just update the fields that are changed
          Map<String, dynamic> data = {
            'events': snap['events']
                .map((e) => e['id'] == widget.event.id ? event.toMap() : e)
                .toList(),
          };

          snap.reference.update(data);

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Event updated successfully',
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'No changes made',
                style: TextStyle(color: Colors.white),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
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
    } catch (e) {
      log('Error saving event: $e');
    }
  }

  @override
  void initState() {
    eventNameController.text = widget.event.name;
    descriptionController.text = widget.event.description;
    locationController.text = widget.event.location;
    organizerController.text = widget.event.organizer;
    startDateAndTimeController.text = widget.event.startDateTime;
    endDateAndTimeController.text = widget.event.endDateTime;

    super.initState();
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
