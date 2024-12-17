import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? phone;
  final String? address;
  final String? photoUrl;

  User({
    this.uid,
    this.email,
    this.displayName,
    this.phone,
    this.address,
    this.photoUrl,
  });

  // Create a copyWith method for easy updates
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phone,
    String? address,
    String? photoUrl,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  // Factory constructor to create from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
    };
  }
}
