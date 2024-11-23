part of 'vehicle_bloc.dart';

sealed class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleLoadingState extends VehicleState {}

class VehiclePriceCalculatedState extends VehicleState {
  final List<Map<String, dynamic>> vehiclePrices;

  const VehiclePriceCalculatedState(this.vehiclePrices);

  @override
  List<Object> get props => [vehiclePrices];
}

class VehicleErrorState extends VehicleState {
  final String error;

  const VehicleErrorState(this.error);

  @override
  List<Object> get props => [error];
}