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

        List<Booking> completedRides = [];
        List<Booking> cancelledRides = [];

        data.forEach((key, value) {
          try {
            final ride =
                Booking.fromJson(key, Map<String, dynamic>.from(value));
            final status = ride.status.toLowerCase();

            if (status == 'trip completed' || status == 'completed') {
              completedRides.add(ride);
            } else if (status == 'customer_cancelled' ||
                status == 'cancelled_by_driver' ||
                status == 'cancelled') {
              cancelledRides.add(ride);
            }
          } catch (e) {
            print('Error processing booking $key: $e');
          }
        });

        // Sort rides by timestamp
        completedRides.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        cancelledRides.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        if (!emit.isDone) {
          emit(RideHistoryLoaded(
            completedRides: completedRides,
            cancelledRides: cancelledRides,
          ));
        }
      } else {
        if (!emit.isDone) {
          emit(RideHistoryLoaded(completedRides: [], cancelledRides: []));
        }
      }
    } catch (e) {
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
