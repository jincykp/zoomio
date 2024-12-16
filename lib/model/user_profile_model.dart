class UserProfile {
  String id; // Unique ID for the user
  String name;
  int age;
  String contactNumber;
  String address;
  String profileImage; // URL or file path for profile image

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.contactNumber,
    required this.address,
    required this.profileImage,
  });

  // Factory method to create a UserProfile instance from JSON (used when fetching data from Firebase)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      contactNumber: json['contactNumber'],
      address: json['address'],
      profileImage: json['profileImage'],
    );
  }

  // Method to convert a UserProfile instance to JSON (used when saving data to Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'contactNumber': contactNumber,
      'address': address,
      'profileImage': profileImage,
    };
  }
}
