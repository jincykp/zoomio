import 'package:flutter/material.dart';

class LocationInfo extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const LocationInfo({
    super.key,
    required this.pickup,
    required this.dropoff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pickup,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                dropoff,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RideDetails extends StatelessWidget {
  final String timestamp;
  final String? completedAt;
  final String price;

  const RideDetails({
    super.key,
    required this.timestamp,
    this.completedAt,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text("Booked at: $timestamp")),
          ],
        ),
        if (completedAt != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.done_all, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text("Completed at: $completedAt")),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.currency_rupee, size: 16),
            const SizedBox(width: 8),
            Text("Total Fare: $price"),
          ],
        ),
      ],
    );
  }
}

class VehicleInfo extends StatelessWidget {
  final Map<String, dynamic> vehicleDetails;

  const VehicleInfo({
    super.key,
    required this.vehicleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Details",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.directions_car, size: 16),
            const SizedBox(width: 8),
            Text(
              "${vehicleDetails['brand']} ${vehicleDetails['vehicleType']}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.airline_seat_recline_normal, size: 16),
            const SizedBox(width: 8),
            Text(
              "Seats: ${vehicleDetails['seatingCapacity']}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        if (vehicleDetails['aboutVehicle'] != null &&
            vehicleDetails['aboutVehicle'].toString().isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehicleDetails['aboutVehicle'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
