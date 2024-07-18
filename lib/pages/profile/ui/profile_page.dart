import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/models/member.dart';
import 'package:event_connect/pages/profile/ui/edit_profile_page.dart';
import 'package:event_connect/pages/profile/widgets/info_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/auth services/auth_services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data found'),
            );
          }

          Member currentUser =
              Member.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return Center(
            child: Column(
              children: [
                // profile image
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1720828800&semt=ais_user',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 16,
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).hintColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(currentUser: currentUser),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // user name
                Text(
                  currentUser.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                InfoTile(
                  title: 'Your Email',
                  value: currentUser.email,
                  icon: Icons.email,
                ),

                const SizedBox(height: 8),

                InfoTile(
                  title: 'Phone Number',
                  value: currentUser.phone.toString(),
                  icon: Icons.phone,
                ),

                const SizedBox(height: 8),

                // sign out button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Sign Out'),
                          content:
                              const Text('Are you sure you want to sign out?'),
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
                                context.read<AuthServices>().signOut(context);
                              },
                              child: const Text('Sign Out'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
