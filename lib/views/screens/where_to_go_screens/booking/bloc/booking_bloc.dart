import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zoomer/services/booking_services_now.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingService bookingService;

  BookingBloc({required this.bookingService}) : super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
    on<UpdateBookingStatus>(_onUpdateBookingStatus);
    on<FetchBooking>(_onFetchBooking);
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(BookingLoading());

      final bookingId = await bookingService.saveBooking(
        userId: event.userId,
        pickupLocation: event.pickupLocation,
        dropOffLocation: event.dropOffLocation,
        vehicleDetails: event.vehicleDetails,
        totalPrice: event.totalPrice,
      );

      final bookingData = await bookingService.getBookingById(bookingId);
      if (bookingData != null) {
        emit(BookingSuccess(bookingId, bookingData));
      } else {
        emit(BookingFailure('Booking created but data retrieval failed'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBookingStatus(
    UpdateBookingStatus event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(BookingLoading());

      await bookingService.updateBookingStatus(
        bookingId: event.bookingId,
        newStatus: event.newStatus,
      );

      emit(BookingStatusUpdated(event.bookingId, event.newStatus));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onFetchBooking(
    FetchBooking event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(BookingLoading());

      final bookingData = await bookingService.getBookingById(event.bookingId);
      if (bookingData != null) {
        emit(BookingSuccess(event.bookingId, bookingData));
      } else {
        emit(BookingFailure('Booking not found'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
