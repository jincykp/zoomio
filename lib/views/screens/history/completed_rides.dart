import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zoomer/views/screens/history/bloc/ride_history_bloc.dart';
import 'package:zoomer/views/screens/history/trip_details.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  String formatDateTime(dynamic timestamp) {
    if (timestamp is int) {
      // Handle integer timestamp (milliseconds since epoch)
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } else if (timestamp is String) {
      // Handle ISO 8601 string timestamp
      try {
        final dateTime = DateTime.parse(timestamp);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } catch (e) {
        print('Error parsing timestamp: $e');
        return 'Invalid date';
      }
    }
    return 'Invalid date';
  }

  String formatPrice(double price) {
    return NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryBloc, RideHistoryState>(
      builder: (context, state) {
        print('Current state: $state');
        if (state is RideHistoryLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: ThemeColors.primaryColor,
          ));
        } else if (state is RideHistoryLoaded) {
          if (state.completedRides.isEmpty) {
            return const Center(
              child: Text(
                'No completed rides yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.completedRides.length,
            itemBuilder: (context, index) {
              final ride = state.completedRides[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            "Completed Ride",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      LocationInfo(
                        pickup: ride.pickupLocation,
                        dropoff: ride.dropOffLocation,
                      ),
                      const SizedBox(height: 16),
                      RideDetails(
                        timestamp: formatDateTime(ride.timestamp),
                        completedAt: formatDateTime(ride.completedAt),
                        price: formatPrice(ride.totalPrice),
                      ),
                      const Divider(height: 24),
                      if (ride.vehicleDetails.isNotEmpty) ...[
                        VehicleInfo(vehicleDetails: ride.vehicleDetails),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is RideHistoryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No data available'));
      },
    );
  }
}

// Assuming you have these widget components defined elsewhere
class LocationInfo extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const LocationInfo({
    Key? key,
    required this.pickup,
    required this.dropoff,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(child: Text(pickup)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(dropoff)),
          ],
        ),
      ],
    );
  }
}

class RideDetails extends StatelessWidget {
  final String timestamp;
  final String completedAt;
  final String price;

  const RideDetails({
    Key? key,
    required this.timestamp,
    required this.completedAt,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Started: $timestamp'),
        const SizedBox(height: 4),
        Text('Completed: $completedAt'),
        const SizedBox(height: 4),
        Text('Total Fare: $price'),
      ],
    );
  }
}

class VehicleInfo extends StatelessWidget {
  final Map<String, dynamic> vehicleDetails;

  const VehicleInfo({
    Key? key,
    required this.vehicleDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle: ${vehicleDetails['brand'] ?? 'N/A'}'),
        if (vehicleDetails['vehicleType'] != null)
          Text('Type: ${vehicleDetails['vehicleType']}'),
        if (vehicleDetails['seatingCapacity'] != null)
          Text('Capacity: ${vehicleDetails['seatingCapacity']} seats'),
      ],
    );
  }
}
