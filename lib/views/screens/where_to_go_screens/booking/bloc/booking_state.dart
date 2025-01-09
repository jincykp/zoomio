part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String bookingId;
  final Map<String, dynamic> bookingData;
  BookingSuccess(this.bookingId, this.bookingData);
}

class BookingFailure extends BookingState {
  final String error;
  BookingFailure(this.error);
}

class BookingStatusUpdated extends BookingState {
  final String bookingId;
  final String status;
  BookingStatusUpdated(this.bookingId, this.status);
}
