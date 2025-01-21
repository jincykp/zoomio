import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zoomer/model/booking_model.dart';
part 'ride_history_event.dart';
part 'ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('bookings');

  StreamSubscription<DatabaseEvent>? _rideSubscription;

  RideHistoryBloc() : super(RideHistoryInitial()) {
    on<LoadRideHistory>((event, emit) async {
      try {
        emit(RideHistoryLoading());

        // Cancel any existing subscription
        await _rideSubscription?.cancel();

        // Get initial data once
        final snapshot = await _database.get();
        if (snapshot.value != null) {
          await _processSnapshot(snapshot, emit);
        }

        // Then set up listener for future updates
        _rideSubscription = _database.onValue.listen(
          (event) async {
            if (!emit.isDone) {
              await _processSnapshot(event.snapshot, emit);
            }
          },
          onError: (error) {
            if (!emit.isDone) {
              emit(RideHistoryError(error.toString()));
            }
          },
        );
      } catch (e) {
        if (!emit.isDone) {
          emit(RideHistoryError(e.toString()));
        }
      }
    });
  }

  Future<void> _processSnapshot(
      DataSnapshot snapshot, Emitter<RideHistoryState> emit) async {
    try {
      if (snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        print('Processing ${data.length} bookings'); // Debug print

        List<Booking> completedRides = [];
        List<Booking> cancelledRides = [];

        data.forEach((key, value) {
          try {
            final bookingData = Map<String, dynamic>.from(value);
            print('Processing booking: $key');
            print('Status: ${bookingData['status']}');
            print('CompletedAt: ${bookingData['completedAt']}'); // Debug print

            final ride = Booking.fromJson(key, bookingData);
            final status = ride.status
                .toLowerCase()
                .trim(); // Added trim() to remove any whitespace

            if (status == 'trip_completed') {
              print('Adding completed ride: $key');
              completedRides.add(ride);
            } else if (status == 'customer_cancelled' ||
                status == 'cancelled_by_driver' ||
                status == 'cancelled' ||
                status == 'cancelled_no_drivers') {
              print('Adding cancelled ride: $key');
              cancelledRides.add(ride);
            }
          } catch (e) {
            print('Error processing booking $key: $e');
          }
        });

        print('Found ${completedRides.length} completed rides');
        print('Found ${cancelledRides.length} cancelled rides');

        // Sort rides by timestamp (most recent first)
        completedRides.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        cancelledRides
            .sort((a, b) => b.tripStartedAt.compareTo(a.tripStartedAt));

        if (!emit.isDone) {
          emit(RideHistoryLoaded(
            completedRides: completedRides,
            cancelledRides: cancelledRides,
          ));
        }
      }
    } catch (e, stackTrace) {
      print('Error in _processSnapshot: $e');
      print('Stack trace: $stackTrace');
      if (!emit.isDone) {
        emit(RideHistoryError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _rideSubscription?.cancel();
    return super.close();
  }
}
