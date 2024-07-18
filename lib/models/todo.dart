// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Todo {
  final String id;
  final String title;
  final String description;
  final String createdDate;
  final String? priority;
  final String? status;
  final int priorityNumber;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.priority,
    this.status,
    required this.priorityNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate,
      'priority': priority,
      'status': status,
      'priorityNumber': priorityNumber,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      createdDate: map['createdDate'] as String,
      priority: map['priority'] != null ? map['priority'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      priorityNumber: map['priorityNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);
}
