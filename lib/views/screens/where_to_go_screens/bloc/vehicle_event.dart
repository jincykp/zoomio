part of 'vehicle_bloc.dart';

sealed class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class CalculatePricesEvent extends VehicleEvent {
  final double distanceInKilometers;

  const CalculatePricesEvent(this.distanceInKilometers);

  @override
  List<Object> get props => [distanceInKilometers];
}

class FetchVehiclesEvent extends VehicleEvent {}
