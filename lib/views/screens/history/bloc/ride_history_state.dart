part of 'ride_history_bloc.dart';

sealed class RideHistoryState extends Equatable {
  const RideHistoryState();

  @override
  List<Object> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class RideHistoryLoaded extends RideHistoryState {
  final List<Booking> completedRides;
  final List<Booking> cancelledRides;

  const RideHistoryLoaded({
    required this.completedRides,
    required this.cancelledRides,
  });

  @override
  List<Object> get props => [completedRides, cancelledRides];
}

class RideHistoryError extends RideHistoryState {
  final String message;

  const RideHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
