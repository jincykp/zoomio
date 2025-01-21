class Booking {
  final String bookingId;
  final int acceptedAt;
  final int completedAt; // Changed to int since it's a timestamp
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
    // Handle integer conversion for completedAt
    int parseTimestamp(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return 0;
        }
      }
      return 0;
    }

    return Booking(
      bookingId: id,
      acceptedAt: json['acceptedAt'] ?? 0,
      completedAt: parseTimestamp(json['completedAt']),
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

  // Helper method to get the formatted completedAt date
  String get formattedCompletedAt {
    if (completedAt == 0) return '';
    return DateTime.fromMillisecondsSinceEpoch(completedAt).toString();
  }
}
