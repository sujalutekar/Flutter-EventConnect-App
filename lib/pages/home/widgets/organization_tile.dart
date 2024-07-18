import 'package:flutter/material.dart';

import '../../../constants/truncate_string.dart';
import '../../../models/organization.dart';
import '../../organization/ui/organization_details_page.dart';

class OrganizationTile extends StatelessWidget {
  final Organization organization;

  const OrganizationTile({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetailsPage(org: organization),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            .copyWith(right: 0),
        padding: const EdgeInsets.all(8),
        height: 200,
        width: 330,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organization.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              truncateString(
                text: organization.description,
                wordLimit: 16,
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.people,
                ),
                const SizedBox(width: 4),
                Text('Members: ${organization.members.length} '),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
