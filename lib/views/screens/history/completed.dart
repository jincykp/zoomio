import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zoomer/views/screens/history/bloc/ride_history_bloc.dart';
import 'package:zoomer/views/screens/history/trip_details.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  String formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
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
          return const Center(child: CircularProgressIndicator());
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
                      if (ride.vehicleDetails != null) ...[
                        VehicleInfo(vehicleDetails: ride.vehicleDetails!),
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
