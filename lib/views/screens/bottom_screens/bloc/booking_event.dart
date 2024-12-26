// part of 'booking_bloc.dart';

// sealed class BookingEvent extends Equatable {
//   const BookingEvent();

//   @override
//   List<Object> get props => [];
// }

// class InitiateBooking extends BookingEvent {
//   final String userId;
//   final String pickupLocation;
//   final String dropOffLocation;
//   final Map<String, dynamic> vehicleDetails;

//   InitiateBooking({
//     required this.userId,
//     required this.pickupLocation,
//     required this.dropOffLocation,
//     required this.vehicleDetails,
//   });
// }

// class DriverAcceptedBooking extends BookingEvent {
//   final String driverId;
//   final Map<String, dynamic> driverDetails;

//   DriverAcceptedBooking({
//     required this.driverId,
//     required this.driverDetails,
//   });
// }
