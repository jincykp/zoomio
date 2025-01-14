part of 'ride_history_bloc.dart';

sealed class RideHistoryEvent extends Equatable {
  const RideHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadRideHistory extends RideHistoryEvent {}
