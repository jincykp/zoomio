part of 'selected_vehicle_cubit.dart';

sealed class SelectedVehicleState extends Equatable {
  const SelectedVehicleState();

  @override
  List<Object> get props => [];
}

final class SelectedVehicleInitial extends SelectedVehicleState {}

class VehicleLoading extends SelectedVehicleState {}

class VehicleLoaded extends SelectedVehicleState {
  final Map<String, dynamic> vehicle;

  VehicleLoaded(this.vehicle);
}

class VehicleError extends SelectedVehicleState {
  final String message;

  VehicleError(this.message);
}
