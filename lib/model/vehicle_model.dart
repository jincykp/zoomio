import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? id;
  String vehicleType;
  String brand;
  String registrationNumber;
  int seatingCapacity;
  String fuelType;
  String insurancePolicyNumber;
  DateTime insuranceExpiryDate;
  String pollutionCertificateNumber;
  DateTime pollutionExpiryDate;
  double baseFare;
  double waitingCharge;
  double perKilometerCharge;
  List<String> vehicleImages;
  List<String> documentImages;
  double? totalPrice; // Optional field
  String aboutVehicle; // New field

  Vehicle({
    this.id,
    required this.vehicleType,
    required this.brand,
    required this.registrationNumber,
    required this.seatingCapacity,
    required this.fuelType,
    required this.insurancePolicyNumber,
    required this.insuranceExpiryDate,
    required this.pollutionCertificateNumber,
    required this.pollutionExpiryDate,
    required this.baseFare,
    required this.waitingCharge,
    required this.perKilometerCharge,
    required this.vehicleImages,
    required this.documentImages,
    this.totalPrice,
    required this.aboutVehicle, // Updated constructor
  });

  // Factory method to create a Vehicle instance from Firestore data
  factory Vehicle.fromMap(Map<String, dynamic> map, String id) {
    return Vehicle(
      id: id,
      vehicleType: map['vehicleType'] ?? '',
      brand: map['brand'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      seatingCapacity: map['seatingCapacity'] ?? 0,
      fuelType: map['fuelType'] ?? '',
      insurancePolicyNumber: map['insurancePolicyNumber'] ?? '',
      insuranceExpiryDate: (map['insuranceExpiryDate'] as Timestamp).toDate(),
      pollutionCertificateNumber: map['pollutionCertificateNumber'] ?? '',
      pollutionExpiryDate: (map['pollutionExpiryDate'] as Timestamp).toDate(),
      baseFare: (map['baseFare'] ?? 0).toDouble(),
      waitingCharge: (map['waitingCharge'] ?? 0).toDouble(),
      perKilometerCharge: (map['perKilometerCharge'] ?? 0).toDouble(),
      vehicleImages: List<String>.from(map['vehicleImages'] ?? []),
      documentImages: List<String>.from(map['documentImages'] ?? []),
      totalPrice: map['totalPrice'] != null
          ? (map['totalPrice'] as num).toDouble()
          : null,
      aboutVehicle: map['aboutVehicle'] ?? '', // Updated fromMap
    );
  }

  // Method to convert a Vehicle instance to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType,
      'brand': brand,
      'registrationNumber': registrationNumber,
      'seatingCapacity': seatingCapacity,
      'fuelType': fuelType,
      'insurancePolicyNumber': insurancePolicyNumber,
      'insuranceExpiryDate': Timestamp.fromDate(insuranceExpiryDate),
      'pollutionCertificateNumber': pollutionCertificateNumber,
      'pollutionExpiryDate': Timestamp.fromDate(pollutionExpiryDate),
      'baseFare': baseFare,
      'waitingCharge': waitingCharge,
      'perKilometerCharge': perKilometerCharge,
      'vehicleImages': vehicleImages,
      'documentImages': documentImages,
      if (totalPrice != null) 'totalPrice': totalPrice,
      'aboutVehicle': aboutVehicle, // Updated toMap
    };
  }

  // Method to create a new instance with updated fields
  Vehicle copyWith({
    String? id,
    String? vehicleType,
    String? brand,
    String? registrationNumber,
    int? seatingCapacity,
    String? fuelType,
    String? insurancePolicyNumber,
    DateTime? insuranceExpiryDate,
    String? pollutionCertificateNumber,
    DateTime? pollutionExpiryDate,
    double? baseFare,
    double? waitingCharge,
    double? perKilometerCharge,
    List<String>? vehicleImages,
    List<String>? documentImages,
    double? totalPrice,
    String? aboutVehicle, // New parameter for copyWith
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleType: vehicleType ?? this.vehicleType,
      brand: brand ?? this.brand,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      fuelType: fuelType ?? this.fuelType,
      insurancePolicyNumber:
          insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
      pollutionCertificateNumber:
          pollutionCertificateNumber ?? this.pollutionCertificateNumber,
      pollutionExpiryDate: pollutionExpiryDate ?? this.pollutionExpiryDate,
      baseFare: baseFare ?? this.baseFare,
      waitingCharge: waitingCharge ?? this.waitingCharge,
      perKilometerCharge: perKilometerCharge ?? this.perKilometerCharge,
      vehicleImages: vehicleImages ?? this.vehicleImages,
      documentImages: documentImages ?? this.documentImages,
      totalPrice: totalPrice ?? this.totalPrice,
      aboutVehicle: aboutVehicle ?? this.aboutVehicle, // Updated copyWith
    );
  }
}
