// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:zoomer/services/booking_services.dart';

// part 'booking_event.dart';
// part 'booking_state.dart';

// class BookingBloc extends Bloc<BookingEvent, BookingState> {
//   final BookingService _bookingService;
//   StreamSubscription? _bookingSubscription;

//   BookingBloc(this._bookingService) : super(BookingInitial()) {
//     on<InitiateBooking>(_onInitiateBooking);
//     on<DriverAcceptedBooking>(_onDriverAcceptedBooking);
//   }

//   Future<void> _onInitiateBooking(
//     InitiateBooking event,
//     Emitter<BookingState> emit,
//   ) async {
//     emit(BookingInProgress());

//     try {
//       // Capture the bookingId
//       final bookingId = await _bookingService.saveBooking(
//         userId: event.userId,
//         pickupLocation: event.pickupLocation,
//         dropOffLocation: event.dropOffLocation,
//         vehicleDetails: event.vehicleDetails,
//       );

//       emit(DriverSearching());

//       // Listen to booking status changes using the bookingId
//       _bookingSubscription?.cancel();
//       _bookingSubscription = FirebaseDatabase.instance
//           .ref()
//           .child('bookings')
//           .child(bookingId) // Use the captured bookingId here
//           .onValue
//           .listen((event) async {
//         if (event.snapshot.exists) {
//           final data = Map<String, dynamic>.from(event.snapshot.value as Map);

//           if (data['status'] == 'driver_accepted') {
//             final driverId = data['driverId'];
//             if (driverId != null) {
//               try {
//                 final driverDoc = await FirebaseFirestore.instance
//                     .collection('driverProfiles')
//                     .doc(driverId)
//                     .get();

//                 if (driverDoc.exists) {
//                   add(DriverAcceptedBooking(
//                     driverId: driverId,
//                     driverDetails: driverDoc.data()!,
//                   ));
//                 }
//               } catch (e) {
//                 emit(BookingError('Error fetching driver details: $e'));
//               }
//             }
//           }
//         }
//       });
//     } catch (e) {
//       emit(BookingError(e.toString()));
//     }
//   }

//   Future<void> _onDriverAcceptedBooking(
//     DriverAcceptedBooking event,
//     Emitter<BookingState> emit,
//   ) async {
//     emit(DriverAccepted(
//       driverId: event.driverId,
//       driverDetails: event.driverDetails,
//     ));
//   }

//   @override
//   Future<void> close() {
//     _bookingSubscription?.cancel();
//     return super.close();
//   }
// }
