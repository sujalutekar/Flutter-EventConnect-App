import 'package:event_connect/pages/home/qr/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../models/organization.dart';
import '../../../models/todo.dart';
import '../../organization/ui/join_organization_page.dart';
import '../../organization/ui/organizations_page.dart';
import '../../profile/ui/profile_page.dart';
import '../../todo/create_todo.dart';
import '../widgets/organization_tile.dart';
import '../widgets/todo_tile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _buildScreens = const [
    HomePage(),
    OrganizationsPage(),
    JoinOrganizationPage(),
    Center(
      child: Text('History Page'),
    ),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        duration: const Duration(milliseconds: 1500),
        itemPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Organizations
          SalomonBottomBarItem(
            icon: const Icon(Icons.people_alt_rounded),
            title: const Text("Orgs"),
            selectedColor: Colors.pink,
          ),

          /// Join Organization
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_business_rounded),
            title: const Text("Join Org"),
            selectedColor: Colors.pink,
          ),

          /// History / Past Events
          SalomonBottomBarItem(
            icon: const Icon(Icons.history_rounded),
            title: const Text("History"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      body: _buildScreens[_currentIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EventConnect'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QRScanner(),
                ),
              );
            },
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Organization(s)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // organization tiles
            StreamBuilder(
                stream: firestore.collection('allOrganizations').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occurred'),
                    );
                  }

                  // get the organizations where the current user is a member
                  var userOrganizations = snapshot.data?.docs.where((doc) {
                    var members = doc['members'] as List<dynamic>;
                    return members.any(
                        (member) => member['uid'] == auth.currentUser?.uid);
                  }).toList();

                  return userOrganizations!.isEmpty
                      ? const Center(
                          child: Text('No Organizations Joined'),
                        )
                      : SizedBox(
                          height: 185,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: userOrganizations.length,
                            itemBuilder: (context, index) {
                              Organization organization = Organization.fromMap(
                                  userOrganizations[index].data());

                              return OrganizationTile(
                                  organization: organization);
                            },
                          ),
                        );
                }),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Todo(s)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // todo tiles
            StreamBuilder(
              stream: firestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('todo')
                  // .orderBy('createdDate', descending: true)
                  .orderBy('priorityNumber', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred'),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No todos found, Create one now :)'),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // bool to expand the todo tile for each todo

                    var data = snapshot.data!.docs[index].data();
                    Todo todo = Todo.fromMap(data);

                    return TodoTile(todo: todo);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
