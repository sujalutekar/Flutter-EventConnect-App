// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:event_connect/models/member.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String location;
  final String startDateTime;
  final String endDateTime;
  final String organizer;
  final List<Member> attendees;
  final String createdDate;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.startDateTime,
    required this.endDateTime,
    required this.organizer,
    this.attendees = const [],
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'organizer': organizer,
      'attendees': attendees.map((x) => x.toMap()).toList(),
      'createdDate': createdDate,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      startDateTime: map['startDateTime'] as String,
      endDateTime: map['endDateTime'] as String,
      organizer: map['organizer'] as String,
      attendees: (map['attendees'] as List)
          .map((item) => Member.fromMap(item))
          .toList(),
      createdDate: map['createdDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);
}
