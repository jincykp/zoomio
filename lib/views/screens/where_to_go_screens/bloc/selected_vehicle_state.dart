part of 'selected_vehicle_bloc.dart';

sealed class SelectedVehicleState extends Equatable {
  const SelectedVehicleState();

  @override
  List<Object> get props => [];
}

final class SelectedVehicleInitial extends SelectedVehicleState {}

class VehicleInitialState extends SelectedVehicleState {}

class VehicleSelectedState extends SelectedVehicleState {
  final Vehicle selectedVehicle;

  VehicleSelectedState(this.selectedVehicle);
}

class VehicleDeselectedState extends SelectedVehicleState {}
