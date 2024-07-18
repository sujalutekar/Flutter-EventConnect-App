// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Member {
  final String uid;
  final String name;
  final int numberOfYourOrg;
  final String email;
  final int phone;

  Member({
    required this.uid,
    required this.name,
    required this.numberOfYourOrg,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'numberOfYourOrg': numberOfYourOrg,
      'email': email,
      'phone': phone,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      uid: map['uid'] as String,
      name: map['name'] as String,
      numberOfYourOrg: map['numberOfYourOrg'] as int,
      email: map['email'] as String,
      phone: map['phone'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);
}
