// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/event.dart';
import './edit_event_page.dart';
import './qr_code_page.dart';

class EventsPage extends StatefulWidget {
  final String orgId;
  final List<Event> events;

  const EventsPage({
    super.key,
    required this.events,
    required this.orgId,
  });

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> deleteEvent(String id, String orgId, int index) async {
      try {
        DocumentReference ref = FirebaseFirestore.instance
            .collection('allOrganizations')
            .doc(orgId);

        if (widget.events[index].id == id) {
          ref.update({
            'events': FieldValue.arrayRemove([widget.events[index].toMap()]),
          });

          widget.events
              .removeWhere((element) => element.id == widget.events[index].id);
          setState(() {});
        }
      } catch (e) {
        log('Error deleting event: $e');
      }
    }

    void deleteButtonPressed(int index) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Event'),
            content: const Text('Are you sure you want to delete this event?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  // show another dialog to confirm deletion
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            titleTextStyle: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'This action cannot be undone.\nAre you sure you want to delete this event?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // delete the organization
                                  await deleteEvent(
                                    widget.events[index].id,
                                    widget.orgId,
                                    index,
                                  );
                                  log('Event deleted');

                                  // pop the dialog
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  // navigate to home page
                                  Navigator.of(context).pop();

                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: 'Event deleted successfully!',
                                  );
                                },
                                child: const Text('Delete'),
                              ),
                            ]);
                      });
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: widget.events.isEmpty
          ? const Center(
              child: Text(
                'No Events!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                return Container(
                  constraints: const BoxConstraints(
                    maxHeight: 250,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.events[index].name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(widget.events[index].location),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.events[index].description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => QRCodePage(
                                            orgId: widget.orgId,
                                            eId: widget.events[index].id,
                                            eventName:
                                                widget.events[index].name,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Get OR Code',
                                      style: TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                // edit button
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditEventPage(
                                          organizationId: widget.orgId,
                                          event: widget.events[index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),

                                // delete button
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      deleteButtonPressed(index);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
