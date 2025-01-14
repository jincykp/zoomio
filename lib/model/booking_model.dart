import 'package:zoomer/model/vehicle_model.dart';

class Booking {
  final String bookingId;
  final int acceptedAt;
  final String completedAt;
  final String driverId;
  final String dropOffLocation;
  final String pickupLocation;
  final String status;
  final String timestamp;
  final double totalPrice;
  final int tripStartedAt;
  final String userId;
  final Map<String, dynamic> vehicleDetails;

  Booking({
    required this.bookingId,
    required this.acceptedAt,
    required this.completedAt,
    required this.driverId,
    required this.dropOffLocation,
    required this.pickupLocation,
    required this.status,
    required this.timestamp,
    required this.totalPrice,
    required this.tripStartedAt,
    required this.userId,
    required this.vehicleDetails,
  });

  factory Booking.fromJson(String id, Map<String, dynamic> json) {
    return Booking(
      bookingId: id,
      acceptedAt: json['acceptedAt'] ?? 0,
      completedAt: json['completedAt'] ?? '',
      driverId: json['driverId'] ?? '',
      dropOffLocation: json['dropOffLocation'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      tripStartedAt: json['tripStartedAt'] ?? 0,
      userId: json['userId'] ?? '',
      vehicleDetails: Map<String, dynamic>.from(json['vehicleDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'acceptedAt': acceptedAt,
      'completedAt': completedAt,
      'driverId': driverId,
      'dropOffLocation': dropOffLocation,
      'pickupLocation': pickupLocation,
      'status': status,
      'timestamp': timestamp,
      'totalPrice': totalPrice,
      'tripStartedAt': tripStartedAt,
      'userId': userId,
      'vehicleDetails': vehicleDetails,
    };
  }

  // Helper method to get minimal vehicle details needed for booking
  static Map<String, dynamic> getVehicleDetailsForBooking(Vehicle vehicle) {
    return {
      'aboutVehicle': vehicle.aboutVehicle,
      'brand': vehicle.brand,
      'seatingCapacity': vehicle.seatingCapacity,
      'totalPrice': vehicle.totalPrice,
      'vehicleType': vehicle.vehicleType,
    };
  }

  // Helper method to create a new instance with updated fields
  Booking copyWith({
    String? bookingId,
    int? acceptedAt,
    String? completedAt,
    String? driverId,
    String? dropOffLocation,
    String? pickupLocation,
    String? status,
    String? timestamp,
    double? totalPrice,
    int? tripStartedAt,
    String? userId,
    Map<String, dynamic>? vehicleDetails,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      driverId: driverId ?? this.driverId,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      totalPrice: totalPrice ?? this.totalPrice,
      tripStartedAt: tripStartedAt ?? this.tripStartedAt,
      userId: userId ?? this.userId,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
    );
  }
}
