import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/event.dart';
import '../../../models/member.dart';
import '../../../models/organization.dart';
import '../organization_provider/add_organization.dart';
import '../widgets/upcoming_event_tile.dart';
import './members_page.dart';
import './create_event_page.dart';
import './events_page.dart';

class OrganizationDetailsPage extends StatelessWidget {
  final Organization org;

  const OrganizationDetailsPage({
    super.key,
    required this.org,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final AddOrganization addOrg =
        Provider.of<AddOrganization>(context, listen: false);

    // check if the user is currentuser or not boolean
    final bool isAdmin = auth.currentUser!.uid == org.adminId;

    void deleteButtonPressed() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Organization'),
            content: const Text(
                'Are you sure you want to delete this organization?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // show another dialog to confirm the delete
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
                            'This action cannot be undone.\nAre you sure you want to delete this organization?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // delete the organization
                              addOrg.deleteOrganization(
                                organizationId: org.id,
                              );

                              // pop the dialog
                              Navigator.of(context).pop();

                              // navigate to home page
                              Navigator.of(context).pop();

                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Organization deleted successfully',
                              );
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
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
        title: Text(org.name),
        actions: [
          isAdmin
              ? PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {
                          // navigate to edit organization page
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: () {
                          // hide the popup menu
                          Navigator.of(context).pop();

                          // delete the organization from the firebase
                          try {
                            deleteButtonPressed();
                          } catch (e) {
                            log('Error deleting organization: $e');
                          }
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateEventPage(organizationId: org.id),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  org.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 4),
                    Text(org.location),
                    const Spacer(),
                    const Icon(Icons.person_4_rounded),
                    const SizedBox(width: 4),
                    isAdmin
                        ? const Text('Admin: You')
                        : Text('Admin: ${org.adminName}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ID: ${org.id}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: org.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.copy,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // members and events list button in a row
              isAdmin
                  ? Row(
                      children: [
                        // Members
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              List<Member> members = org.members;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MembersPage(members: members),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 4),
                                  Text('Members'),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Events
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              List<Event> events = org.events;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EventsPage(
                                    orgId: org.id,
                                    events: events,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.event),
                                  SizedBox(width: 4),
                                  Text('Events'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 16),

              // upcoming events
              if (org.events.isEmpty)
                const Text(
                  'No upcoming events',
                  style: TextStyle(fontSize: 20),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    UpcomingEventTile(org: org),
                    const SizedBox(height: 26),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
