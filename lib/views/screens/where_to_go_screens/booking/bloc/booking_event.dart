part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final String userId;
  final String pickupLocation;
  final String dropOffLocation;
  final Map<String, dynamic> vehicleDetails;
  final double totalPrice;

  CreateBooking({
    required this.userId,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.vehicleDetails,
    required this.totalPrice,
  });
}

class UpdateBookingStatus extends BookingEvent {
  final String bookingId;
  final String newStatus;

  UpdateBookingStatus({
    required this.bookingId,
    required this.newStatus,
  });
}

class FetchBooking extends BookingEvent {
  final String bookingId;
  FetchBooking(this.bookingId);
}
