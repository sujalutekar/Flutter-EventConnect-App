import 'package:flutter/material.dart';

import '../../../models/member.dart';

class MembersPage extends StatelessWidget {
  final List<Member> members;

  const MembersPage({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              title: Text(members[index].name),
              subtitle: Text(members[index].phone.toString()),
              tileColor: Theme.of(context).cardColor,
            ),
          );
        },
      ),
    );
  }
}
