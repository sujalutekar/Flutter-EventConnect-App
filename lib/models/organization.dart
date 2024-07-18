// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../models/event.dart';
import '../models/member.dart';

class Organization {
  final String id;
  final String name;
  final String description;
  final String location;
  final String contactEmail;
  final String contactPhone;
  final String createdDate;
  final String adminId;
  final String adminName;
  final List<Member> members;
  final List<Event> events;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.contactEmail,
    required this.contactPhone,
    required this.createdDate,
    required this.adminId,
    required this.adminName,
    this.members = const [],
    this.events = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'createdDate': createdDate,
      'adminId': adminId,
      'adminName': adminName,
      'members': members.map((x) => x.toMap()).toList(),
      'events': events.map((x) => x.toMap()).toList(),
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      contactEmail: map['contactEmail'] as String,
      contactPhone: map['contactPhone'] as String,
      createdDate: map['createdDate'] as String,
      adminId: map['adminId'] as String,
      adminName: map['adminName'] as String,
      members:
          (map['members'] as List).map((item) => Member.fromMap(item)).toList(),
      events:
          (map['events'] as List).map((item) => Event.fromMap(item)).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) =>
      Organization.fromMap(json.decode(source) as Map<String, dynamic>);
}
